Page = require("../page")
Character = require("../../models").Character
QuestGroup = require("../../game_data").QuestGroup
Quest = require("../../game_data").Quest
Pagination = require("../../lib/pagination")
modals = require('../modals')
request = require('../../lib/request')

class QuestsPage extends Page
  className: "quests page"

  QUEST_GROUPS_PER_PAGE = 5
  QUESTS_PER_PAGE = 3

  hide: ->
    super

  show: (groupId)->
    @character = Character.first() # first!

    super

    @firstLoading = true

    @loading = true

    @.render()

    data = {}
    data.group_id = groupId

    request.send('load_quests', data)

  render: ->
    if @loading
      @.renderPreloader()
    else
      @html(@.renderTemplate("quests/index"))

  renderTabs: ->
    @el.find('.tabs').html(@.renderTemplate("quests/tabs"))

  renderQuestList: ->
    @el.find('.quest_list').html(@.renderTemplate("quests/quest_list"))

  bindEventListeners: ->
    super

    request.bind('quest_loaded', @.onDataLoaded)
    request.bind('quest_performed', @.onQuestPerformed)
    request.bind('quest_group_completed', @.onQuestGroupCompleted)

    @el.on('click', '.tabs .paginate:not(.disabled)', @.onTabsPaginateButtonClick)
    @el.on('click', '.tab:not(.current)', @.onTabClick)
    @el.on('click', '.quest_list .paginate:not(.disabled)', @.onQuestsPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)
    @el.on('click', 'button.perform:not(.disabled)', @.onPerformClick)
    @el.on('click', '.group_reward .view', @.onGroupRewardViewClick)
    @el.on('click', '.group_reward .collect:not(.disabled)', @.onGroupRewardCollectClick)

    @character.bind("update", @.onCharacterUpdate)

  unbindEventListeners: ->
    super

    request.unbind('quest_loaded', @.onDataLoaded)
    request.unbind('quest_performed', @.onQuestPerformed)
    request.unbind('quest_group_completed', @.onQuestGroupCompleted)

    @el.off('click', '.tabs .paginate:not(.disabled)', @.onTabsPaginateButtonClick)
    @el.off('click', '.tab:not(.current)', @.onTabClick)
    @el.off('click', '.quest_list .paginate:not(.disabled)', @.onQuestsPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)
    @el.off('click', 'button.perform:not(.disabled)', @.onPerformClick)
    @el.off('click', '.group_reward .view', @.onGroupRewardViewClick)
    @el.off('click', '.group_reward .collect:not(.disabled)', @.onGroupRewardCollectClick)

    @character.unbind("update", @.onCharacterUpdate)

  onTabsPaginateButtonClick: (e)=>
    @paginatedQuestGroups = @questGroupsPagination.paginate(@questGroups,
      back: $(e.currentTarget).data('type') == 'back'
    )

    @.renderTabs()

  onTabClick: (e)=>
    @el.find(".tab").removeClass("current")

    tabEl = $(e.currentTarget)
    tabEl.addClass("current")

    @el.find('.quest_list').html("<div class='loading'></div>")

    request.send('load_quests', group_id: tabEl.data('group-id'))

  onQuestsPaginateClick: (e)=>
    @painatedQuests = @questsPagination.paginate(@quests,
      back: $(e.currentTarget).data('type') == 'back'
    )

    @.renderQuestList()

  onSwitchPageClick: (e)=>
    @painatedQuests = @questsPagination.paginate(@quests,
      start_count: ($(e.currentTarget).data('page') - 1) * @questsPagination.per_page
    )

    @.renderQuestList()

  onDataLoaded: (response)=>
    @loading = false

    @currentGroup = QuestGroup.find(response.current_group_id)

    if @firstLoading
      @questGroupsPagination = new Pagination(QUEST_GROUPS_PER_PAGE)
      @questsPagination = new Pagination(QUESTS_PER_PAGE)

      @questGroups = _.sortBy(QuestGroup.all(), (q)-> q.position)

      groupStartCount = 0

      if @currentGroup
        console.log index = _.findIndex(@questGroups, (g)=> g.id == @currentGroup.id)
        groupStartCount = Math.floor(index / QUEST_GROUPS_PER_PAGE) * QUEST_GROUPS_PER_PAGE

      @paginatedQuestGroups = @questGroupsPagination.paginate(@questGroups, start_count: groupStartCount)

    @completedGroupIds = response.completed_group_ids
    @groupIsCompleted = response.group_is_completed
    @groupCanComplete = response.group_can_complete

    @.defineQuests(response.quests)

    @painatedQuests = @questsPagination.paginate(@quests, initialize: true)
    @questsPagination.setSwitches(@quests)

    if @firstLoading
      @.render()
    else
      @.renderQuestList()

    @firstLoading = false

  defineQuests: (quests)->
    @quests = (
      for [quest_id, steps, level_number, completed] in quests
        @.prepareQuestData(quest_id, steps, level_number, completed)
    )

  prepareQuestData: (quest_id, steps, level_number, completed)->
    quest = Quest.find(quest_id)
    level = if @groupIsCompleted then quest.lastLevel() else quest.levelByNumber(level_number)

    progress = {
      steps: steps
      completed: @groupIsCompleted || completed
    }

    [quest, level, progress]

  updatedQuestList: (quest, level, progress)->
    if index = _.findIndex(@quests, (data)-> data[0].id == quest.id)
      @quests[index] = [quest, level, progress]

  onPerformClick: (e)->
    button = $(e.currentTarget)
    button.addClass('disabled')

    request.send('perform_quest', quest_id: button.data('quest-id'))

  onQuestPerformed: (response)=>
    if response.isError && response.error_code in ['quest_group_is_completed', 'not_reached_level']
      @.displayError(I18n.t("quests.errors.#{ response.error_code }"))

      request.send('load_quests', group_id: @currentGroup.id) if response.reload

      return

    if response.data.questsProgress? # обновление всего списка квестов
      @.defineQuests(response.data.questsProgress)

      @painatedQuests = @questsPagination.paginate(@quests, initialize: true)
      @questsPagination.setSwitches(@quests)

      @.renderQuestList()

    else # обновление прогресса для одного квеста
      # обновление данных
      [quest, level, progress] = @.prepareQuestData(
        response.data.quest_id, response.data.progress...
      )

      @.updatedQuestList(quest, level, progress)

      # обновление блока с наградой для группы
      if response.data.group_can_complete?
        if @groupCanComplete != response.data.group_can_complete
          @groupCanComplete = response.data.group_can_complete

          @el.find('.group_reward').replaceWith(@.renderTemplate("quests/group_reward"))
        else
          @groupCanComplete = response.data.group_can_complete

      # обновление виузальной части прогресса для квеста
      quest_el = @el.find("#quest_#{response.data.quest_id}")
      quest_el.find('.progress_wrapper').replaceWith(
        @.renderTemplate('quests/quest_progress', quest: quest, level: level, progress: progress)
      )

    # показ диалога завершения или попапса с наградами за пройденный шаг
    if response.data.quest_completed || response.data.group_can_complete
      modals.QuestPerformResultModal.show(response, @currentGroup.id)

    else
      unless response.error_code == 'quest_is_completed'
        button = quest_el.find("button.perform")
        button.removeClass('disabled')

        title = (
          if response.is_error
            I18n.t("quests.errors.#{ response.error_code }")
          else
            null
        )

      @.displayResult(button || quest_el.find('.completed')
        {
          reward: response.data.reward
          requirement: response.data.requirement
          type: if response.error_code? then 'failure' else 'success'
          title: title
        }
        {
          position: 'left'
        }
      )

  onGroupRewardViewClick: (e)=>
    @.displayReward($(e.currentTarget)
      @currentGroup.reward.collect
      {position: 'left'}
    )

  onGroupRewardCollectClick: (e)=>
    $(e.currentTarget).addClass('disabled')

    request.send('complete_quests_group', @currentGroup.id)

  onQuestGroupCompleted: (response)=>
    modals.QuestPerformResultModal.close()

    @groupCanComplete = response.data.group_can_complete
    @groupIsCompleted = response.data.group_is_completed

    @el.find('.group_reward').replaceWith(@.renderTemplate("quests/group_reward"))

    if response.is_error
      @.displayError(I18n.t("quests.errors.#{ response.error_code }"))
    else
      nextGroup = QuestGroup.findByAttribute('position', @currentGroup.position + 1)

      modals.QuestGroupCompleteResultModal.show(
        context: @
        reward: response.data.reward
        next_group_id: nextGroup?.id
      )

  onCharacterUpdate: (character)=>
    @.renderTabs() if character.changes().level?

module.exports = QuestsPage
