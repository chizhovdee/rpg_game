_ = require('lodash')
QuestGroup = require('../game_data').QuestGroup
executor = require('../executors').quests

CharacterState = require('../models').CharacterState
Character = require('../models').Character

module.exports =
  index: (req, res)->
    CharacterState.fetchForRead(req.db, req.currentUser.id)
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
      characterState = new CharacterState(yield CharacterState.fetchForUpdate(t, req.currentUser.id))
      characterState.setCharacter(
        new Character(yield Character.fetchForUpdate(t, req.currentUser.id))
      )

      result = executor.performQuest(_.toInteger(req.body.quest_id), characterState)

#      yield t.none('update characters set experience=$1 where id=$2', [
#        character.experience + 1, character.id, character.level
#      ])
#
#      yield t.none("update character_states set quests=$1 where character_id=$2",
#        [character.quests().state(), character.id]
#      )

    )
    .then((result)->
      result = res.parseResult(result)

      if result.isError()
        switch result.errorCode
          when 'not_reached_level'
            res.sendEvent('not_reached_level')

      else
        res.sendEvent("quest_performed", result)
    )
    .catch((error)->
      res.sendEventError(error)
    )




