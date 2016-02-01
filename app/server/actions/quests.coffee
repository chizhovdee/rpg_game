_ = require('lodash')

module.exports =
  performQuest: (req, callback)->
    req.currentCharacter.withState(req.db, ->
      quests = req.currentCharacter.quests()

      result = quests.perform(_.toInteger(req.body.quest_id))



      callback()
    )
