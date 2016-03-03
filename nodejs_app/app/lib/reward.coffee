# Rewards:
# - energy
# - health
# - basic_money
# - vip_money
# - experience

class Reward
  values: null
  character: null
  characterState: null

  constructor: (@character, @characterState)->
    @values = {}

  get: (key)->
    @values[key]

  # метод применяет награду к простым аттрибутам
  simpleAttribute: (attribute, value)->
    # проверяем на существование оба объекта
    # для большей целостности данных
    if @characterState || @character
      result = (
        switch attribute
          when 'energy'
            @character.updateRestorable('ep', value)
          when 'health'
            @character.updateRestorable('hp', value)
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
    else
      @.push(attribute, value)

  energy: (value)->
    @.simpleAttribute('energy', value)

  health: (value)->
    @.simpleAttribute('health', value)

  basicMoney: (value)->
    @.simpleAttribute('basic_money', value)

  vipMoney: (value)->
    @.simpleAttribute('vip_money', value)

  experience: (value)->
    @.simpleAttribute('experience', value)

  push: (key, value)->
    if @values[key]
      @values[key] += value
    else
      @values[key] = value

  forClient: ->
    @values

module.exports = Reward
