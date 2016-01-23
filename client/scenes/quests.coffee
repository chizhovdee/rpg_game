Scene = require("../lib/scene")
sceneManager = require("../lib/scene_manager")
Character = require("../models/character")
QuestGroup = require("../game_data").QuestGroup
Quest = require("../game_data").Quest
Pagination = require("../lib/pagination")

class QuestsScene extends Scene
  className: "quests scene"

  QUEST_GROUPS_PER_PAGE = 5
  QUESTS_PER_PAGE = 3

  hide: ->
    super

  show: ->
    super

    @questGroupsPagination = new Pagination(QUEST_GROUPS_PER_PAGE)

    @questsPagination = new Pagination(QUESTS_PER_PAGE)

    @questGroups = QuestGroup.all()

    @paginatedQuestGroups = @questGroupsPagination.paginate(@questGroups, initialize: true)

    @currentQuestGroupKey = @paginatedQuestGroups[0].key

    @quests = Quest.findAllByAttribute("quest_group_key", @currentQuestGroupKey)

    @painatedQuests = @questsPagination.paginate(@quests, initialize: true)

    @questsPagination.setSwitches(@quests)

    @.render()

  render: ->
    @html(@.renderTemplate("quests/index"))

  renderTabs: ->
    @el.find('.tabs').html(@.renderTemplate("quests/tabs"))

  renderQuestList: ->
    @el.find('.quest_list').html(@.renderTemplate("quests/quest_list"))

  bindEventListeners: ->
    super

    @el.on('click', '.tabs .paginate:not(.disabled)', (e)=> @.onTabsPaginateButtonClick(e))
    @el.on("click", ".tab:not(.current)", (e)=> @.onTabClick(e))
    @el.on('click', '.quest_list .paginate:not(.disabled)', (e)=> @.onQuestsPaginateClick(e))
    @el.on('click', '.switches .switch', (e)=> @.onSwitchPageClick(e))

  unbindEventListeners: ->
    super

    @el.off('click', '.tabs .paginate:not(.disabled)', (e)=> @.onTabsPaginateButtonClick(e))
    @el.off("click", ".tab:not(.current)", (e)=> @.onTabClick(e))
    @el.off('click', '.quest_list .paginate:not(.disabled)', (e)=> @.onQuestsPaginateClick(e))
    @el.off('click', '.switches .switch', (e)=> @.onSwitchPageClick(e))

  onTabsPaginateButtonClick: (e)->
    @paginatedQuestGroups = @questGroupsPagination.paginate(@questGroups,
      back: $(e.currentTarget).data('type') == 'back'
    )

    @.renderTabs()

  onTabClick: (e)->
    @el.find(".tab").removeClass("current")

    tabEl = $(e.currentTarget)
    tabEl.addClass("current")

    @currentQuestGroupKey = tabEl.data('tab')

    @quests = Quest.findAllByAttribute("quest_group_key", @currentQuestGroupKey)

    @painatedQuests = @questsPagination.paginate(@quests, initialize: true)

    @.renderQuestList()

  onQuestsPaginateClick: (e)->
    @painatedQuests = @questsPagination.paginate(@quests,
      back: $(e.currentTarget).data('type') == 'back'
    )

    @.renderQuestList()

  onSwitchPageClick: (e)->
    @painatedQuests = @questsPagination.paginate(@quests,
      start_count: ($(e.currentTarget).data('page') - 1) * @questsPagination.per_page
    )

    @.renderQuestList()


module.exports = QuestsScene
