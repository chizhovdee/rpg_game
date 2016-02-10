_ = require('lodash')
QuestGroup = require('../game_data/quest_group')
actions = require('../actions/quests')

CharacterState = require('../models/character_state')
Character = require('../models/character')

module.exports =
  index: (req, res)->
    req.currentCharacter.withState(req.db, ->
      console.log "State obj", req.currentCharacter.state

      group = QuestGroup.find(_.toInteger(req.query.group)) if req.query.group
      group ?= req.currentCharacter.quests().currentGroup()

      data = {}
      data.quests = req.currentCharacter.quests().questsWithProgressByGroup(group)
      data.by_group = true if req.query.group
      data.current_group = group.id

      res.eventResponse.add("quest_loaded", data)
      res.json(res.eventResponse.all())
    )

  perform: (req, res)->
    console.log 'body', req.body.quest_id

    req.db.tx((t)->
      data = yield Character.fetchForUpdate(t, 1)
      req.currentCharacter = new Character(data)

      data = yield CharacterState.fetchForUpdate(t, req.currentCharacter.id)
      req.currentCharacter.state = new CharacterState(data)

      actions.performQuest(req)

      yield t.none('update characters set experience=$1 where id=$2', [
        req.currentCharacter.experience + 1, req.currentCharacter.id, req.currentCharacter.level
      ])

      yield t.none("update character_states set quests=$1 where character_id=$2",
        [req.currentCharacter.quests().state(), req.currentCharacter.id]
      )
    )
    .then((data)->
      console.log('success')

      res.json({})
    )
    .catch((error)->
       console.error(error)
    )




