Scene = require("../lib/scene.js")
sceneManager = require("../lib/scene_manager.js")
Character = require("../models/character.js")
#QuestGroup = require("../game_data/quest_group.js")
#Quest = require("../game_data/quest.js")
Pagination = require("../lib/pagination.js")

class QuestsScene extends Scene
  className: "quests scene"

  QUEST_GROUPS_PER_PAGE = 4
  QUESTS_PER_PAGE = 3

  hide: ->
    super

  show: ->
    super

    @questGroupsPagination = new Pagination(QUEST_GROUPS_PER_PAGE)
    #@questsPagination = new Pagination(QUESTS_PER_PAGE)

    @questGroups = QuestGroup.all()

    @paginatedQuestGroups = @questGroupsPagination.paginate(@questGroups, initialize: true)

    @currentQuestGroupKey = @paginatedQuestGroups[0].key

    @quests = Quest.findAllByAttribute("quest_group_key", @currentQuestGroupKey)

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

  unbindEventListeners: ->
    super

    @el.off('click', '.tabs .paginate:not(.disabled)', (e)=> @.onTabsPaginateButtonClick(e))
    @el.off("click", ".tab:not(.current)", (e)=> @.onTabClick(e))

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

    @.renderQuestList()

module.exports = QuestsScene
