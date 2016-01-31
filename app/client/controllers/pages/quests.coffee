Page = require("../../lib/base_page")
Character = require("../../models/character")
QuestGroup = require("../../game_data/quest_group")
Quest = require("../../game_data/quest")
Pagination = require("../../lib/pagination")
QuestPerformPopup = require('../popups/quest_perform_result')
transport = require('../../lib/transport')

class QuestsPage extends Page
  className: "quests page_block"

  QUEST_GROUPS_PER_PAGE = 5
  QUESTS_PER_PAGE = 3

  hide: ->
    super

  show: ->
    super

    @loading = true

    @.render()

    transport.send('load_quests')

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

    transport.bind('quest_loaded', @.onDataLoaded)

    @el.on('click', '.tabs .paginate:not(.disabled)', @.onTabsPaginateButtonClick)
    @el.on('click', '.tab:not(.current)', @.onTabClick)
    @el.on('click', '.quest_list .paginate:not(.disabled)', @.onQuestsPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)
    @el.on('click', 'button.perform:not(.disabled)', @.onPerformClick)

  unbindEventListeners: ->
    super

    transport.unbind('quest_loaded', @.onDataLoaded)

    @el.on('click', '.tabs .paginate:not(.disabled)', @.onTabsPaginateButtonClick)
    @el.on('click', '.tab:not(.current)', @.onTabClick)
    @el.on('click', '.quest_list .paginate:not(.disabled)', @.onQuestsPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)
    @el.on('click', 'button.perform:not(.disabled)', @.onPerformClick)

  onTabsPaginateButtonClick: (e)=>
    @paginatedQuestGroups = @questGroupsPagination.paginate(@questGroups,
      back: $(e.currentTarget).data('type') == 'back'
    )

    @.renderTabs()

  onTabClick: (e)=>
    @el.find(".tab").removeClass("current")

    tabEl = $(e.currentTarget)
    tabEl.addClass("current")

    @currentQuestGroupKey = tabEl.data('tab')

    @quests = Quest.findAllByAttribute("quest_group_key", @currentQuestGroupKey)

    @painatedQuests = @questsPagination.paginate(@quests, initialize: true)

    @questsPagination.setSwitches(@quests)

    @.renderQuestList()

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
    $(e.currentTarget).addClass('disabled')

    QuestPerformPopup.show()

  onDataLoaded: (response)=>
    @loading = false

    console.log response

    unless response.by_group
      @questGroupsPagination = new Pagination(QUEST_GROUPS_PER_PAGE)
      @questsPagination = new Pagination(QUESTS_PER_PAGE)

      @questGroups = QuestGroup.all()
      @paginatedQuestGroups = @questGroupsPagination.paginate(@questGroups, initialize: true)

    @currentGroup = QuestGroup.find(response.current_group)

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

    @.render()

module.exports = QuestsPage
