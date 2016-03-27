BaseState = require('./base_state')

class ItemsState extends BaseState
  defaultState: {}
  stateName: "items"

  giveItem: (itemId, value = 1)->
    @state[itemId] ?= 0

    @state[itemId] += value

    @.update()

  takeItem: (itemId, value = 1)->
    return unless @state[itemId]?

    @state[itemId] -= value

    delete @state[itemId] if @state[itemId] <= 0

    @.update()

  count: (itemId)->
    @state[itemId] || 0

module.exports = ItemsState