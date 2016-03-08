Quest = require('../game_data').Quest
Result = require('../lib/result')
Reward = require('../lib/reward')
Requirement = require('../lib/requirement')

module.exports =
  performQuest: (quest_id, character)->
    # TODO проверка на завершенность миссии

    quest = Quest.find(quest_id)

    if character.level < quest.group().level
      return new Result(errorCode: 'not_reached_level')

    questsState = character.state.questsState()

    level = questsState.levelFor(quest)

    unless level.requirement.viewOn('perform').isSatisfiedFor(character)
      return new Result(
        errorCode: 'requirements_not_satisfied'
        data:
          quest_id: quest.id
          requirement: level.requirement.viewOn('perform').unSatisfiedFor(character)
      )

    questsState.perform(quest)

    reward = new Reward(character)

    level.requirement.applyOn('perform', reward)
    level.reward.applyOn('perform', reward)

    new Result(
      data:
        reward: reward
        quest_id: quest.id
        progress: questsState.progressFor(quest)
    )


