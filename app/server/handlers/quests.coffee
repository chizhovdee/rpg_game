_ = require('lodash')
QuestGroup = require('../game_data/quest_group')

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


