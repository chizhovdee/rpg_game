Quest = require('../game_data').Quest
QuestGroup = require('../game_data').QuestGroup
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

    questCompleted = questsState.questIsCompleted(quest)

    # здесь проверяем на возможность перехода на новый уровень
    # здесь также меняется стейт
    if questCompleted && questsState.canGoToNextLevelFor(quest.group)
      questsState.goToNextLevelFor(quest.group)

    # apply rewards
    reward = new Reward(character)
    level.requirement.applyOn('perform', reward)
    level.reward.applyOn('perform', reward)
    level.reward.applyOn('complete', reward) if questCompleted

    new Result(
      data:
        reward: reward
        quest_id: quest.id
        progress: questsState.progressFor(quest)
        questCompleted: questCompleted
        groupCanComplete: questCompleted && questsState.groupCanComplete(quest.group)
    )

  completeGroup: (group_id, character)->
    group = QuestGroup.find(group_id)

    questsState = character.state.questsState()

    if questsState.groupIsCompleted(group)
      return new Result(errorCode: 'quest_group_is_completed')

    unless questsState.groupCanComplete(group)
      return new Result(errorCode: 'quest_group_cannot_complete')

    questsState.completeGroup(group)

    reward = new Reward(character)
    group.reward.applyOn('collect', reward)

    new Result(
      data:
        reward: reward
        group_id: group.id
    )

