Quest = require('../game_data').Quest
Result = require('../lib/result')
Reward = require('../lib/reward')
Requirement = require('../lib/requirement')

module.exports =
  performQuest: (quest_id, character)->
    quest = Quest.find(quest_id)

    if character.level < quest.group.level
      return new Result(errorCode: 'not_reached_level')

    questsState = character.state.questsState()

    level = questsState.levelFor(quest)

    # TODO if group in groups_completed

    if questsState.questIsCompleted(quest)
      return new Result(
        errorCode: 'quest_is_completed'
        data:
          quest_id: quest.id
          progress: questsState.progressFor(quest)
      )

    unless level.requirement.viewOn('perform').isSatisfiedFor(character)
      return new Result(
        errorCode: 'requirements_not_satisfied'
        data:
          quest_id: quest.id
          progress: questsState.progressFor(quest)
          requirement: level.requirement.viewOn('perform').unSatisfiedFor(character)
      )

    questsState.perform(quest, level)

    reward = new Reward(character)

    level.requirement.applyOn('perform', reward)
    level.reward.applyOn('perform', reward)

    new Result(
      data:
        reward: reward
        quest_id: quest.id
        progress: questsState.progressFor(quest)
        groupCanComplete: questsState.questIsCompleted(quest) && questsState.groupCanComplete(quest.group)
    )


