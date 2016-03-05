Quest = require('../game_data').Quest
Result = require('../lib/result')
Reward = require('../lib/reward')

module.exports =
  performQuest: (quest_id, character)->
    # TODO проверка на завершенность миссии

    quest = Quest.find(quest_id)

    if character.level < quest.group().level
      return new Result(errorCode: 'not_reached_level')

    questsState = character.state.questsState()

    level = questsState.levelFor(quest)

    unless level.requirement.isSatisfiedFor(character)
      return new Result(errorCode: 'requirements_not_satisfied')

    questsState.perform(quest)

    reward = new Reward(character)

    level.requirement.apply(reward)

    new Result(
      data:
        reward: reward
        quest_id: quest.id
        progress: questsState.progressFor(quest)
    )


