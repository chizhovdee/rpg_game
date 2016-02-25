_ = require('lodash')
QuestGroup = require('../game_data').QuestGroup
executor = require('../executors').quests

CharacterState = require('../models').CharacterState
Character = require('../models').Character

module.exports =
  index: (req, res)->
    req.db.task((t)->
      t.batch([
        Character.fetchForRead(t, req.currentUser.id)
        CharacterState.fetchForRead(t, req.currentUser.id)
      ])
    )
    .then((character, state)->
      character = new Character(character)
      character.state = new CharacterState(state)

      group = QuestGroup.find(_.toInteger(req.query.group)) if req.query.group
      group ?= character.quests().currentGroup()

      data = {}
      data.quests = character.quests().questsWithProgressByGroup(group)
      data.by_group = true if req.query.group
      data.current_group = group.id

      res.sendEvent("quest_loaded", data)
    )
    .catch((err)->
      res.sendEventError(err)
    )

  perform: (req, res)->
    req.db.tx((t)->
      character = new Character(yield Character.fetchForUpdate(t, req.currentUser.id))
      character.state = new CharacterState(yield character.fetchStateForUpdate(t))

      result = executor.performQuest(_.toInteger(req.body.quest_id), character)

      yield t.none('update characters set experience=$1 where id=$2', [
        character.experience + 1, character.id, character.level
      ])

      yield t.none("update character_states set quests=$1 where character_id=$2",
        [character.quests().state(), character.id]
      )

      result = {}
    )
    .then((result)->
      res.sendEvent("quest_performed", result)
    )
    .catch((error)->
      res.sendEventError(error)
    )




