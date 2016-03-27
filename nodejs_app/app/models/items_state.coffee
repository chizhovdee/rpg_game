BaseState = require('./base_state')

class ItemsState extends BaseState
  defaultState: {}
  stateName: "items"

  giveItem: (itemId, amount = 1)->
    @state[itemId] ?= 0

    @state[itemId] += amount

    @.update()

  takeItem: (itemId, amount = 1)->
    return unless @state[itemId]?

    @state[itemId] -= amount

    delete @state[itemId] if @state[itemId] <= 0

    @.update()

  count: (itemId)->
    @state[itemId] || 0

module.exports = ItemsState