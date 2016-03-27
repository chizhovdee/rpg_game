_ = require('lodash')

class BaseState
  defaultState: null
  stateName: null # должен совпадать с полем в бд таблице

  constructor: (@characterState)->
    throw new Error("character state undefined") unless @characterState?
    throw new Error("stateName is undefined") unless @stateName?
    throw new Error("defaultState is undefined") unless @defaultState?

    state = (
      if @characterState[@stateName]
        _.cloneDeep(@characterState[@stateName])
      else
        _.defaultsDeep({}, @defaultState)
    )

    Object.defineProperty(@, 'state',
      value: state
      writable: false
      enumerable: true
    )

  update: ->
    @characterState[@stateName] = @state

module.exports = BaseState