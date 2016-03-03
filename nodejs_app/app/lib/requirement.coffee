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

  isSatisfiedFor: (characterState)->
     for key, value of @values
       switch key
         when 'energy'
           return false if value > characterState.character.restorable('ep')

         when 'health'
           return false if value > characterState.character.restorable('hp')

         when 'basic_money'
           return false if value > characterState.character.basic_money

         when 'vip_money'
           return false if value > characterState.character.vip_money

     true

  # reward is instance of Reward class
  apply: (reward)->



  forClient: ->
    @values

module.exports = Requirement
