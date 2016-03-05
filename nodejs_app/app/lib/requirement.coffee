# Требования:
# - energy
# - health
# - basic_money
# - vip_money

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

  isSatisfiedFor: (character)->
    for key, value of @values
      switch key
        when 'energy'
          return false if value > character.ep

        when 'health'
          return false if value > character.hp

        when 'basic_money'
          return false if value > character.basic_money

        when 'vip_money'
          return false if value > character.vip_money

    true

  # reward is instance of Reward class
  apply: (reward)->
    for key, value of @values
      switch key
        when 'energy'
          reward.takeEnergy(value)
        when 'health'
          reward.takeHealth(value)
        when 'basic_money'
          reward.takeBasicMoney(value)
        when 'vip_money'
          reward.takeVipMoney(value)

  toJSON: ->
    @values

module.exports = Requirement
