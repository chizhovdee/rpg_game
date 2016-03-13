_ = require("lodash")
Base = require('./base')

class Character extends Base
  FULL_REFILL_DURATION = _(12).hours()
  HP_RESTORE_DURATION  = _(1).minutes()
  EP_RESTORE_DURATION  = _(15).seconds()

  DEFAULT_ATTRIBUTES = {
    level: 1
    hp: 100
    health: 100
    energy: 20
    ep: 20
    basic_money: 50
    vip_money: 1
    experience: 0
    points:  0
  }

#  DATABASE_FIELDS = [
#    'social_id'
#    'level'
#    'experience'
#    'basic_money'
#    'vip_money'
#    'hp'
#    'ep'
#    'health'
#    'energy'
#    'points'
#    'session_key'
#    'session_secret_key'
#    'installed'
#    'last_visited_at'
#    'created_at'
#    'updated_at'
#  ]

  @createDefault: ->
    new @(DEFAULT_ATTRIBUTES)

  constructor: ->
    super

    for attribute in ['hp', 'ep']
      @.defineRestorableAttribute(attribute)

  defineRestorableAttribute: (attribute)->
    Object.defineProperty(@, attribute,
      enumerable: true
      get: -> @.restorable(attribute)
      set: (newValue)->
        newValue = @.restorable(attribute) + @.updatedValueRestorable(attribute, newValue)

        return if @.restorable(attribute) == newValue

        @changes[attribute] = [@["_#{ attribute }"], newValue] # [old, new]

        @["_#{ attribute }"] = newValue

        @["#{attribute}_updated_at"] = new Date()

        _.addUniq(@changed, attribute)

        @isChanged = true

        @["_#{ attribute }"] # return new value
    ) if @["_#{ attribute }"]?

  insertToDb: (db)->
    fields = [
      'social_id', 'level', 'experience', 'ep', 'energy', 'hp', 'health', 'basic_money', 'vip_money',
      'points', 'session_key', 'session_secret_key', 'installed',
      'last_visited_at', 'created_at', 'updated_at', 'ep_updated_at', 'hp_updated_at'
    ]

    @last_visited_at = @created_at = @updated_at = @ep_updated_at = @hp_updated_at = new Date()

    db.one("""
      insert into characters(#{ fields.join(', ') })
                    values(#{ fields.map((f)-> "${#{ f }}").join(', ') })
                    returning *
    """, @)

  setState: (state)->
    Object.defineProperty(@, 'state'
      value: state
      configurable: false
      enumerable: true
      writable: false
    )

  healthPoints: ->
    @health

  energyPoints: ->
    @energy

  restorable: (attribute)->
    switch attribute
      when "hp"
        total = @.healthPoints()
      when "ep"
        total = @.energyPoints()

    if @["_#{ attribute }"] >= total
      @["_#{ attribute }"]

    else if @["#{attribute}_updated_at"].valueOf() < Date.now() - FULL_REFILL_DURATION
      total
    else
      value = @["_#{ attribute }"] + @.restoresSinceLastUpdate(attribute)

      value = 0 if value < 0

      if value >= total
        total
      else
        value

  updatedValueRestorable: (attribute, value)->
    restorable = @.restorable(attribute)

    if value > 0
      if @.isFull(attribute)
        0
      else if (left = @.leftToFull(attribute)) && left < value
        left
      else
        value

    else if value < 0
      if restorable - value < 0
        value - restorable
      else
        value
    else
      0

  restoresSinceLastUpdate: (attribute)->
    Math.floor(
      (Date.now() - @["#{attribute}_updated_at"].valueOf()) / @.restoreDuration(attribute)
    )

  restoreDuration: (attribute)->
    switch attribute
      when "hp"
        duration = HP_RESTORE_DURATION
      when "ep"
        duration = EP_RESTORE_DURATION

    duration * (100 - @.restoreBonus(attribute)) / 100

  timeToRestore: (attribute)->
    if @.isFull(attribute)
      0
    else
      restoreDuration = @.restoreDuration(attribute)

      restoreDuration - ((Date.now() - @["#{attribute}_updated_at"].valueOf()) % restoreDuration)

  isFull: (attribute)->
    switch attribute
      when "hp"
        @.restorable(attribute) >= @.healthPoints()
      when "ep"
        @.restorable(attribute) >= @.energyPoints()

  leftToFull: (attribute)->
    switch attribute
      when "hp"
        @.healthPoints() - @.restorable(attribute)
      when "ep"
        @.energyPoints() - @.restorable(attribute)

  restoreBonus: (attribute)->
    0

  forClient: ->
    id: @id
    level: @level
    restorable_ep: @ep
    energy_points: @.energyPoints()
    restorable_hp: @hp
    health_points: @.healthPoints()
    experience: @experience
    basic_money: @basic_money
    vip_money: @vip_money
    hp_restore_in: @.timeToRestore("hp")
    ep_restore_in: @.timeToRestore("ep")


module.exports = Character