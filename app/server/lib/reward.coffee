class Reward
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

  experience: (value)->
    @.push('experience', value)

  push: (key, value)->
    if @values[key]
      @values[key] += value
    else
      @values[key] = value

  forClient: ->
    @values

module.exports = Reward
