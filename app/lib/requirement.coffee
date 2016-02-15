class Requirement
  values: null
  character: null

  constructor: (@character = null)->
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

  isSatisfied: (key, value)->
    # TO DO
    # @character

  forClient: ->
    if @character?
    else
      @values

module.exports = Requirement
