Quest = require('../game_data').Quest
QuestGroup = require('../game_data').QuestGroup
Result = require('../lib/result')
Reward = require('../lib/reward')
Requirement = require('../lib/requirement')

module.exports =
  performQuest: (quest_id, character)->
    quest = Quest.find(quest_id)

    questsState = character.state.questsState()

    questsProgress = null # используется для передачи на клиент

    if questsState.groupIsCompleted(quest.group)
      return new Result(errorCode: 'quest_group_is_completed', reload: true)

    if character.level < quest.group.level
      return new Result(errorCode: 'not_reached_level')

    level = questsState.levelFor(quest)

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

      questsProgress = questsState.questsWithProgressByGroup(quest.group)

    # apply rewards
    reward = new Reward(character)
    level.requirement.applyOn('perform', reward)
    level.reward.applyOn('perform', reward)
    level.reward.applyOn('complete', reward) if questCompleted

    result = new Result(
      data:
        reward: reward
        quest_id: quest.id
        questCompleted: questCompleted
        groupCanComplete: questCompleted && questsState.groupCanComplete(quest.group)
    )

    if questsProgress
      result.data.questsProgress = questsProgress
    else
      result.data.progress = questsState.progressFor(quest)

    result

  completeGroup: (group_id, character)->
    group = QuestGroup.find(group_id)

    questsState = character.state.questsState()

    groupIsCompleted = questsState.groupIsCompleted(group)
    groupCanComplete = questsState.groupCanComplete(group)

    if groupIsCompleted
      return new Result(
        errorCode: 'quest_group_is_completed'
        data:
          groupIsCompleted: groupIsCompleted
          groupCanComplete: groupCanComplete
      )

    unless groupCanComplete
      return new Result(
        errorCode: 'quest_group_cannot_complete'
        data:
          groupIsCompleted: groupIsCompleted
          groupCanComplete: groupCanComplete
      )

    questsState.completeGroup(group)

    reward = new Reward(character)
    group.reward.applyOn('collect', reward)

    new Result(
      data:
        reward: reward
        groupIsCompleted: true
        groupCanComplete: false
    )

