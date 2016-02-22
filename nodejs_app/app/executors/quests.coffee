
module.exports =
  performQuest: (quest_id, character)->
    quests = character.quests()

    result = quests.perform(quest_id)


