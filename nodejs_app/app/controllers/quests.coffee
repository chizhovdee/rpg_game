_ = require('lodash')
QuestGroup = require('../game_data').QuestGroup
executor = require('../executors').quests

CharacterState = require('../models').CharacterState
Character = require('../models').Character

module.exports =
  index: (req, res)->
    CharacterState.fetchForRead(req.db, character_id: req.currentUser.id)
    .then((state)->
      characterState = new CharacterState(state)

      if req.query.group_id
        group = QuestGroup.find(_.toInteger(req.query.group_id))
      else
        group = characterState.questsState().currentGroup()

      data = {}
      data.quests = characterState.questsState().questsWithProgressByGroup(group)
      data.by_group = true if req.query.group_id
      data.current_group_id = group.id

      res.sendEvent("quest_loaded", data)
    )
    .catch((err)->
      res.sendEventError(err)
    )

  perform: (req, res)->
    req.db.tx((t)->
      character = new Character(yield Character.fetchForUpdate(t, id: req.currentUser.id))

      character.setState(
        new CharacterState(yield CharacterState.fetchForUpdate(t, character_id: req.currentUser.id))
      )

      result = executor.performQuest(_.toInteger(req.body.quest_id), character)

      @.batch([character.update(t), character.state.update(t), result])
    )
    .then((result)->
      result = res.parseResult(result)

      if result.isError()
        switch result.errorCode
          when 'not_reached_level'
            res.sendEvent('not_reached_level')

          else
            res.sendEvent('quest_perform_failure', result)

      else
        res.sendEvent("quest_perform_success", result)
    )
    .catch((error)->
      res.sendEventError(error)
    )




