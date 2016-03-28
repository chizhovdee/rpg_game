BaseState = require('./base_state')
Item = require('../game_data').Item

class ItemsState extends BaseState
  defaultState: {}
  stateName: "items"

  giveItem: (item, amount = 1)->
    unless item instanceof Item
      item = Item.find(item)

    throw new Error('not correct item') unless item.id

    @state[item.id] ?= 0
    @state[item.id] += amount

    @.update()

    [item, amount]

  takeItem: (item, amount = 1)->
    unless item instanceof Item
     item = Item.find(item)

    throw new Error('not correct item') unless item.id

    unless @state[item.id]?
      return [item, 0]

    amount = @state[item.id] if @state[item.id] < amount

    @state[item.id] -= amount

    delete @state[item.id] if @state[item.id] <= 0

    @.update()

    [item, amount]

  count: (itemId)->
    @state[itemId] || 0

module.exports = ItemsState