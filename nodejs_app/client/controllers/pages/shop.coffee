Page = require("../page")
Character = require("../../models").Character
Pagination = require("../../lib").Pagination
modals = require('../modals')
request = require('../../lib/request')

ItemGroup = require('../../game_data').ItemGroup
Item = require('../../game_data').Item

GROUPS_PER_PAGE = 5
ITEMS_PER_PAGE = 6
LOCKED_ITEMS_COUNT = 2

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
    request.bind('item_purchased', @.onItemPurchased)

    @el.on('click', '.tabs .paginate:not(.disabled)', @.onTabsPaginateButtonClick)
    @el.on('click', '.tab:not(.current)', @.onTabClick)
    @el.on('click', '.item_list .paginate:not(.disabled)', @.onItemsPaginateClick)
    @el.on('click', '.switches .switch', @.onSwitchPageClick)
    @el.on('click', '.more', @.onMoreButtonClick)
    @el.on('click', '.item button.buy:not(.disabled)', @.onBuyButtonClick)

  unbindEventListeners: ->
    super

    request.unbind('shop_loaded', @.onDataLoaded)
    request.unbind('item_purchased', @.onItemPurchased)

    @el.off('click', '.tabs .paginate:not(.disabled)', @.onTabsPaginateButtonClick)
    @el.off('click', '.tab:not(.current)', @.onTabClick)
    @el.off('click', '.item_list .paginate:not(.disabled)', @.onItemsPaginateClick)
    @el.off('click', '.switches .switch', @.onSwitchPageClick)
    @el.off('click', '.more', @.onMoreButtonClick)
    @el.off('click', '.item button.buy:not(.disabled)', @.onBuyButtonClick)


  onTabsPaginateButtonClick: (e)=>
    @paginatedGroups = @groupsPagination.paginate(@groups,
      back: $(e.currentTarget).data('type') == 'back'
    )

    @lockedGroups = @.findLockedGroups(@paginatedGroups)

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
      @lockedGroups = @.findLockedGroups(@paginatedGroups)

    lockedItemsCount = 0
    @items = Item.select((item)=>
      if item.item_group_key == @currentGroup.key
        if item.level <= @character.level
          true
        else if lockedItemsCount < LOCKED_ITEMS_COUNT
          lockedItemsCount += 1
          true
        else
          false
      else
        false
    )

    @paginatedItems = @itemsPagination.paginate(@items, initialize: true)

    @itemsPagination.setSwitches(@items)

    if @firstLoading
      @.render()
    else
      @.renderItemList()

    @firstLoading = false

  findLockedGroups: (groups)->
    result = []

    for group in groups
      item = Item.detect((item)=>
        item.item_group_key == group.key && item.level <= @character.level
      )

      result.push(group) unless item?

    result

  onMoreButtonClick: (e)=>
    icon = $(e.currentTarget)
    item = Item.find(icon.data('item-id'))

    @.displayPopup(icon, @.renderTemplate('shop/item_info', item: item), position: 'left')

  onBuyButtonClick: (e)=>
    button = $(e.currentTarget)
    button.addClass('disabled')

    request.send('buy_item', item_id: button.data('item-id'))

  onItemPurchased: (response)=>
    console.log 'onItemPurchased', response

    if response.is_error
      switch response.error_code
        when 'not_reached_level', 'item_not_found', 'amount_is_less_than_zero'
          @.displayError(I18n.t("shop.errors.#{ response.error_code }"))

        when 'requirements_not_satisfied'
          button = @el.find("#item_#{response.data.item_id} button.buy")
          button.removeClass('disabled')

          @.displayResult(button
            {
              requirement: response.data.requirement
              type: 'failure'
              title: I18n.t("shop.errors.requirements_not_satisfied")
            }
            {
              position: 'left'
            }
          )
    else
      modals.ItemPurchasedResultModal.show(response)



module.exports = ShopPage
