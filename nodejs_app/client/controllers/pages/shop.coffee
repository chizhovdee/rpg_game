Page = require("../page")
Character = require("../../models").Character
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')

ItemGroup = require('../../game_data').ItemGroup
Item = require('../../game_data').Item

GROUPS_PER_PAGE = 5
ITEMS_PER_PAGE = 3

class ShopPage extends Page
  className: "shop page"

  show: ->
    @character = Character.first() # first!

    super

    @firstLoading = true

    # данные берутся из клиента
    @.onDataLoaded({})

    @.render()

  render: ->
    if @loading
      @.renderPreloader()
    else
      @html(@.renderTemplate("shop/index"))

  renderTabs: ->
    @el.find('.tabs').html(@.renderTemplate("shop/tabs"))

  renderItemList: ->
    @el.find('.item_list').html(@.renderTemplate("shop/item_list"))

  bindEventListeners: ->
    super

    request.bind('shop_loaded', @.onDataLoaded)

    @el.on('click', '.tabs .paginate:not(.disabled)', @.onTabsPaginateButtonClick)
    @el.on('click', '.tab:not(.current)', @.onTabClick)
    @el.on('click', '.item_list .paginate:not(.disabled)', @.onItemsPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)

  unbindEventListeners: ->
    super

    request.unbind('shop_loaded', @.onDataLoaded)

    @el.off('click', '.tabs .paginate:not(.disabled)', @.onTabsPaginateButtonClick)
    @el.off('click', '.tab:not(.current)', @.onTabClick)
    @el.off('click', '.item_list .paginate:not(.disabled)', @.onItemsPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)

  onTabsPaginateButtonClick: (e)=>
    @paginatedGroups = @groupsPagination.paginate(@groups,
      back: $(e.currentTarget).data('type') == 'back'
    )

    @.renderTabs()

  onTabClick: (e)=>
    @el.find(".tab").removeClass("current")

    tabEl = $(e.currentTarget)
    tabEl.addClass("current")

    @el.find('.item_list').html("<div class='loading'></div>")

    @.onDataLoaded(current_group_id: tabEl.data('group-id'))

    #request.send('load_shop', group_id: tabEl.data('group-id'))

  onItemsPaginateClick: (e)=>
    @paginatedItems = @itemsPagination.paginate(@items,
      back: $(e.currentTarget).data('type') == 'back'
    )

    @.renderItemList()

  onSwitchPageClick: (e)=>
    @paginatedItems = @itemsPagination.paginate(@items,
      start_count: ($(e.currentTarget).data('page') - 1) * @itemsPagination.per_page
    )

    @.renderItemList()

  onDataLoaded: (response)=>
    console.log response

    @loading = false

    if response.current_group_id?
      @currentGroup = ItemGroup.find(response.current_group_id)
    else
      @currentGroup = ItemGroup.first()

    if @firstLoading
      @groupsPagination = new Pagination(GROUPS_PER_PAGE)
      @itemsPagination = new Pagination(ITEMS_PER_PAGE)

      @groups = ItemGroup.all()

      groupStartCount = 0

      if @currentGroup
        index = _.findIndex(@groups, (g)=> g.id == @currentGroup.id)
        groupStartCount = Math.floor(index / GROUPS_PER_PAGE) * GROUPS_PER_PAGE

      @paginatedGroups = @groupsPagination.paginate(@groups, start_count: groupStartCount)

    @items = Item.findAllByAttribute('item_group_key', @currentGroup.key)
    @paginatedItems = @itemsPagination.paginate(@items, initialize: true)

    @itemsPagination.setSwitches(@items)

    if @firstLoading
      @.render()
    else
      @.renderItemList()

    @firstLoading = false


module.exports = ShopPage
