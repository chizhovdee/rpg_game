class Requirement
  values: null

  constructor: ->
    @values = {}

  get: (key)->
    @values[key]

  energy: (value)->
    @.push('energy', value)

  basicMoney: (value)->
    @.push('basic_money', value)

  vipMoney: (value)->
    @.push('vip_money', value)

  push: (key, value)->
    if @values[key]
      @values[key] += value
    else
      @values[key] = value

  isSatisfiedFor: (characterState, key, value)->
    # TO DO
    # @character

  forClient: ->
    @values

module.exports = Requirement
