_ = require('lodash')

module.exports =
  performQuest: (req)->
    quests = req.currentCharacter.quests()

    result = quests.perform(_.toInteger(req.body.quest_id))


