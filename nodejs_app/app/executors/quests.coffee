Quest = require('../game_data').Quest
Result = require('../lib/result')

module.exports =
  performQuest: (quest_id, characterState)->
    # TODO проверка на готовность миссии

    character = characterState.character

    quest = Quest.find(quest_id)

    if character.level < quest.group().level
      return new Result(errorCode: 'not_reached_level')

    questsState = characterState.questsState()

    level = questsState.levelFor(quest)

    console.log level.requirement

    result = questsState.perform(quest_id)

    new Result() # return result


