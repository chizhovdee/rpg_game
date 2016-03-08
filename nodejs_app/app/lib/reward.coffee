# Rewards:
# - energy
# - health
# - basic_money
# - vip_money
# - experience

_ = require('lodash')

class Reward
  values: null
  character: null
  characterState: null

  constructor: (@character = null)->
    @values = {}
    @triggers = {}

  on: (trigger)->
    if !trigger || trigger.trim().length == 0
      throw new Error("Argument Error: no correct trigger name for reward")

    @triggers[trigger] ?= new Reward()

  viewOn: (trigger)->
    @triggers[trigger]

  applyOn: (trigger, reward)->
    for key, value of @.viewOn(trigger).values
      switch key
        when 'energy'
          reward.addEnergy(value)
        when 'health'
          reward.addHealth(value)
        when 'basic_money'
          reward.addBasicMoney(value)
        when 'vip_money'
          reward.addVipMoney(value)
        when 'experience'
          reward.addExperience(value)

  get: (key)->
    @values[key]

  # метод применяет награду к простым аттрибутам
  simpleAttribute: (attribute, value)->
    result = (
      switch attribute
        when 'energy'
          oldValue = @character.ep

          @character.ep = value

          @character.ep - oldValue
        when 'health'
          oldValue = @character.hp

          @character.hp = value

          @character.hp - oldValue
        when 'basic_money'
          if @character.basic_money + value < 0
            value = value - @character.basic_money

          @character.basic_money += value

          value
        when 'vip_money'
          if @character.vip_money + value < 0
            value = value - @character.vip_money

          @character.vip_money += value

          value
        when 'experience'
          @character.experience += value

          value
        else
          0
    )

    @.push(attribute, result) if result != 0

  addEnergy: (value)->
    return if value < 0
    @.simpleAttribute('energy', value)

  addHealth: (value)->
    return if value < 0
    @.simpleAttribute('health', value)

  addBasicMoney: (value)->
    return if value < 0
    @.simpleAttribute('basic_money', value)

  addVipMoney: (value)->
    return if value < 0
    @.simpleAttribute('vip_money', value)

  takeEnergy: (value)->
    return if value < 0
    @.simpleAttribute('energy', -value)

  takeHealth: (value)->
    return if value < 0
    @.simpleAttribute('health', -value)

  takeBasicMoney: (value)->
    return if value < 0
    @.simpleAttribute('basic_money', -value)

  takeVipMoney: (value)->
    return if value < 0
    @.simpleAttribute('vip_money', -value)

  addExperience: (value)->
    return if value < 0
    @.simpleAttribute('experience', value)

  energy: (value)->
    @.push('energy', value)

  health: (value)->
    @.push('health', value)

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

  toJSON: ->
    if !_.isEmpty(@triggers)
      @triggers
    else
      @values

module.exports = Reward
