Quest = require('../game_data').Quest

module.exports =
  performQuest: (quest_id, characterState)->
    quests = characterState.getQuests()
    quest = Quest

    result = quests.perform(quest_id)


