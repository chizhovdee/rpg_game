Quest = require('../game_data').Quest
Result = require('../lib/result')
Reward = require('../lib/reward')

module.exports =
  performQuest: (quest_id, characterState)->
    # TODO проверка на завершенность миссии

    character = characterState.character

    quest = Quest.find(quest_id)

    if character.level < quest.group().level
      return new Result(errorCode: 'not_reached_level')

    questsState = characterState.questsState()

    level = questsState.levelFor(quest)

    unless level.requirement.isSatisfiedFor(characterState)
      return new Result(errorCode: 'requirements_not_satisfied')

    if questsState.perform(quest_id)
      reward = new Reward(characterState)

      #level.requirement.apply(reward)

      reward.energy(-1)

      console.log characterState.character


    new Result() # return result


