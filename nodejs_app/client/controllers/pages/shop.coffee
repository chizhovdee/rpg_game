Page = require("../page")
Character = require("../../models").Character
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')

class ShopPage extends Page
  className: "shop page"

  show: ->
    @character = Character.first() # first!

    super

    @firstLoading = true

    @loading = true

    @.render()

  render: ->
    if @loading
      @.renderPreloader()
    else
      @html(@.renderTemplate("shop/index"))

  renderTabs: ->
    @el.find('.tabs').html(@.renderTemplate("shop/tabs"))

  renderItemList: ->
    @el.find('.quest_list').html(@.renderTemplate("shop/item_list"))

  bindEventListeners: ->
    super

    @el.on('click', '.tabs .paginate:not(.disabled)', @.onTabsPaginateButtonClick)
    @el.on('click', '.tab:not(.current)', @.onTabClick)
    @el.on('click', '.shop_list .paginate:not(.disabled)', @.onQuestsPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

    @character.bind("update", @.onCharacterUpdate)

  unbindEventListeners: ->
    super

    @el.off('click', '.tabs .paginate:not(.disabled)', @.onTabsPaginateButtonClick)
    @el.off('click', '.tab:not(.current)', @.onTabClick)
    @el.off('click', '.shop_list .paginate:not(.disabled)', @.onQuestsPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

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


    @firstLoading = false


  onCharacterUpdate: (character)=>
    #@.renderTabs() if character.changes().level?

module.exports = ShopPage
