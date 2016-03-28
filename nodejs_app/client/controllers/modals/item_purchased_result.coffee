Modal = require("../modal")
Item = require('../../game_data').Item

class ItemPurchasedResultModal extends Modal
  className: 'item_purchased_result modal'

  show: (response)->
    super

    @item = Item.find(response.data.item_id)
    @amount = response.data.amount
    @reward = response.data.reward

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('shop/item_purchased_result')
    )

  bindEventListeners: ->
    super


  unbindEventListeners: ->
    super


module.exports = ItemPurchasedResultModal