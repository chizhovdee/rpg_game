Quest = require('../game_data').Quest
QuestGroup = require('../game_data').QuestGroup
lib = require('../lib')
Result = lib.Result
Reward = lib.Reward
Requirement = lib.Requirement

module.exports =
  performQuest: (quest_id, character)->
    quest = Quest.find(quest_id)

    questsState = character.state.questsState()

    questsProgress = null # используется для передачи на клиент

    if questsState.groupIsCompleted(quest.group)
      return new Result(error_code: 'quest_group_is_completed', reload: true)

    if character.level < quest.group.level
      return new Result(error_code: 'not_reached_level')

    level = questsState.levelFor(quest)

    if questsState.questIsCompleted(quest)
      return new Result(
        error_code: 'quest_is_completed'
        data:
          quest_id: quest.id
          progress: questsState.progressFor(quest)
      )

    unless level.requirement.viewOn('perform').isSatisfiedFor(character)
      return new Result(
        error_code: 'requirements_not_satisfied'
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
        quest_completed: questCompleted
        group_can_complete: questCompleted && questsState.groupCanComplete(quest.group)
    )

    if questsProgress
      result.data.questsProgress = questsProgress
    else
      result.data.progress = questsState.progressFor(quest)

    character.checkProgress()

    result

  completeGroup: (group_id, character)->
    group = QuestGroup.find(group_id)

    questsState = character.state.questsState()

    groupIsCompleted = questsState.groupIsCompleted(group)
    groupCanComplete = questsState.groupCanComplete(group)

    if character.level < group.level
      return new Result(
        error_code: 'not_reached_level'
        data:
          group_is_completed: groupIsCompleted
          group_can_complete: groupCanComplete
      )

    if groupIsCompleted
      return new Result(
        error_code: 'quest_group_is_completed'
        data:
          group_is_completed: groupIsCompleted
          group_can_complete: groupCanComplete
      )

    unless groupCanComplete
      return new Result(
        error_code: 'quest_group_cannot_complete'
        data:
          group_is_completed: groupIsCompleted
          group_can_complete: groupCanComplete
      )

    questsState.completeGroup(group)

    reward = new Reward(character)
    group.reward.applyOn('collect', reward)

    character.checkProgress()

    new Result(
      data:
        reward: reward
        group_is_completed: true
        group_can_complete: false
    )

