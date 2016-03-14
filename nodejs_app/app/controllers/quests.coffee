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

      questsState = characterState.questsState()

      if req.query.group_id
        group = QuestGroup.find(_.toInteger(req.query.group_id))
      else
        group = questsState.currentGroup()

      data = {}
      data.quests = questsState.questsWithProgressByGroup(group)
      data.current_group_id = group.id
      data.group_is_completed = questsState.groupIsCompleted(group)
      data.group_can_complete = questsState.groupCanComplete(group)
      data.completed_group_ids = questsState.completedGroupIds()

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

      res.addEvent('quest_performed', result)

      res.addEventProgress(character)

      @.batch([character.update(t), character.state.update(t)])
    )
    .then(->
      res.sendEvents()
    )
    .catch((error)->
      res.sendEventError(error)
    )

  completeGroup: (req, res)->
    req.db.tx((t)->
      character = new Character(yield Character.fetchForUpdate(t, id: req.currentUser.id))

      character.setState(
        new CharacterState(yield CharacterState.fetchForUpdate(t, character_id: req.currentUser.id))
      )

      result = executor.completeGroup(_.toInteger(req.body.group_id), character)

      res.addEvent('quest_group_completed', result)

      res.addEventProgress(character)

      @.batch([character.update(t), character.state.update(t)])
    )
    .then(->
      res.sendEvents()
    )
    .catch((error)->
      res.sendEventError(error)
    )





