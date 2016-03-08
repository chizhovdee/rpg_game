Page = require("../page")
Character = require("../../models").Character
QuestGroup = require("../../game_data").QuestGroup
Quest = require("../../game_data").Quest
Pagination = require("../../lib/pagination")
#QuestPerformResultModal = require('../modals').QuestPerformResultModal
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
    request.bind('quest_perform_failure', @.onQuestPerformFailure)
    request.bind('quest_perform_success', @.onQuestPerformSuccess)

    @el.on('click', '.tabs .paginate:not(.disabled)', @.onTabsPaginateButtonClick)
    @el.on('click', '.tab:not(.current)', @.onTabClick)
    @el.on('click', '.quest_list .paginate:not(.disabled)', @.onQuestsPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)
    @el.on('click', 'button.perform:not(.disabled)', @.onPerformClick)

  unbindEventListeners: ->
    super

    request.unbind('quest_loaded', @.onDataLoaded)
    request.unbind('quest_perform_failure', @.onQuestPerformFailure)
    request.unbind('quest_perform_success', @.onQuestPerformSuccess)

    @el.off('click', '.tabs .paginate:not(.disabled)', @.onTabsPaginateButtonClick)
    @el.off('click', '.tab:not(.current)', @.onTabClick)
    @el.off('click', '.quest_list .paginate:not(.disabled)', @.onQuestsPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)
    @el.off('click', 'button.perform:not(.disabled)', @.onPerformClick)

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

  onPerformClick: (e)=>
    button = $(e.currentTarget)
    button.addClass('disabled')
    #QuestPerformPopup.show()

    request.send('perform_quest', quest_id: button.data('quest-id'))

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
        quest = Quest.find(quest_id)
        level = quest.levelByNumber(level_number)

        progress = {
          steps: steps
          completed: completed
        }

        [quest, level, progress]
    )

    @painatedQuests = @questsPagination.paginate(@quests, initialize: true)
    @questsPagination.setSwitches(@quests)

    if response.by_group
      @.renderQuestList()
    else
      @.render()

  onQuestPerformSuccess: (response)=>
    console.log response

    button = $("#quest_#{response.data.quest_id} button.perform")
    button.removeClass('disabled')

    @.displayResult(button
      {
        reward: response.data.reward
        type: 'success'
      }
      {
        position: 'left'
      }
    )

  onQuestPerformFailure: (response)=>
    console.log response

    button = $("#quest_#{response.data.quest_id} button.perform")
    button.removeClass('disabled')

    @.displayResult(button
      {
        requirement: response.data.requirement
        type: 'failure'
        title: I18n.t('common.requirements_not_satisfied')
      }
      {
        position: 'left'
      }
    )

module.exports = QuestsPage
