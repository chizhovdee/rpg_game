# Rewards:
# - energy
# - health
# - basic_money
# - vip_money
# - experience

_ = require('lodash')

class Reward
  @Item: null
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

  getOn: (trigger)->
    @triggers[trigger]

  applyOn: (trigger, reward)->
    @.getOn(trigger).apply(reward)

  apply: (reward)->
    for key, value of @values
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
        when 'items'
          throw new Error('items reward apply not realized')

  getValue: (key)->
    @values[key]

  # метод применяет награду к простым аттрибутам
  simpleAttribute: (attribute, value)->
    result = (
      switch attribute
        when 'energy'
          oldValue = @character.ep

          @character.ep += value

          @character.ep - oldValue
        when 'health'
          oldValue = @character.hp

          @character.hp += value

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

  # add

  addExperience: (value)->
    return if value < 0
    @.simpleAttribute('experience', value)

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

  giveItem: (item, amount = 1)->
    #TODO edit placements
    return if amount < 1

    itemsState = @character.state.itemsState()

    [item, amount] = itemsState.giveItem(item, amount)

    @.item(item.id, amount)

  # take

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

  takeItem: (item, amount = 1)->
    #TODO edit placements
    return if amount < 1

    itemsState = @character.state.itemsState()

    [item, amount] = itemsState.takeItem(item, amount)

    @.item(item.id, -amount)

  # initialize reward attributes

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

  item: (keyOrId, amount = 1)->
    return if amount == 0

    @values.items ?= {}
    @values.items[keyOrId] ?= 0
    @values.items[keyOrId] += amount

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
