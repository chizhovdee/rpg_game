Page = require("../page")
Character = require("../../models").Character
QuestGroup = require("../../game_data").QuestGroup
Quest = require("../../game_data").Quest
Pagination = require("../../lib/pagination")
QuestPerformResultModal = require('../modals').QuestPerformResultModal
request = require('../../lib/request')

class QuestsPage extends Page
  className: "quests page"

  QUEST_GROUPS_PER_PAGE = 5
  QUESTS_PER_PAGE = 3

  hide: ->
    super

  show: ->
    super

    @loading = true

    @.render()

    request.send('load_quests')

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

  onTabsPaginateButtonClick: (e)=>
    @paginatedQuestGroups = @questGroupsPagination.paginate(@questGroups,
      back: $(e.currentTarget).data('type') == 'back'
    )

    @.renderTabs()

  onTabClick: (e)=>
    console.log 'click'
    @el.find(".tab").removeClass("current")

    tabEl = $(e.currentTarget)
    tabEl.addClass("current")

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

    console.log response

    unless response.by_group
      @questGroupsPagination = new Pagination(QUEST_GROUPS_PER_PAGE)
      @questsPagination = new Pagination(QUESTS_PER_PAGE)

      @questGroups = QuestGroup.all()
      @paginatedQuestGroups = @questGroupsPagination.paginate(@questGroups, initialize: true)

    @currentGroup = QuestGroup.find(response.current_group_id)

    @quests = (
      for [quest_id, steps, level_number, completed] in response.quests
        @.prepareQuestData(quest_id, steps, level_number, completed)
    )

    @painatedQuests = @questsPagination.paginate(@quests, initialize: true)
    @questsPagination.setSwitches(@quests)

    @groupIsCompleted = response.groupIsCompleted
    @groupCanComplete = response.groupCanComplete

    if response.by_group
      @.renderQuestList()
    else
      @.render()

  prepareQuestData: (quest_id, steps, level_number, completed)->
    quest = Quest.find(quest_id)
    level = quest.levelByNumber(level_number)

    progress = {
      steps: steps
      completed: completed
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
    console.log response

    [quest, level, progress] = @.prepareQuestData(
      response.data.quest_id, response.data.progress...
    )

    @.updatedQuestList(quest, level, progress)

    if @groupCanComplete != response.data.groupCanComplete
      @groupCanComplete = response.data.groupCanComplete

      @el.find('.group_reward').replaceWith(@.renderTemplate("quests/group_reward"))
    else
      @groupCanComplete = response.data.groupCanComplete

    quest_el = @el.find("#quest_#{response.data.quest_id}")
    quest_el.find('.progress_info').replaceWith(
      @.renderTemplate('quests/quest_progress', quest: quest, level: level, progress: progress)
    )

    unless response.errorCode == 'quest_is_completed'
      button = quest_el.find("button.perform")
      button.removeClass('disabled')

    title = (
      switch response.errorCode
        when 'requirements_not_satisfied'
          I18n.t('common.requirements_not_satisfied')
        when 'quest_is_completed'
          I18n.t('quests.quest_is_completed')
        else
          null
    )

    if response.data.questCompleted || response.data.groupCanComplete
      QuestPerformResultModal.show(response)
    else
      @.displayResult(button || quest_el.find('.completed')
        {
          reward: response.data.reward
          requirement: response.data.requirement
          type: if response.errorCode? then 'failure' else 'success'
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
    console.log response



module.exports = QuestsPage
