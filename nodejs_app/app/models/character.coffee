_ = require("lodash")
Base = require('./base')

class Character extends Base
  @include require('./modules/character_restores')

  DEFAULT_DB_ATTRIBUTES = {
    level: 1
    hp: 100
    health: 100
    energy: 20
    ep: 20
    basic_money: 50
    vip_money: 1
    experience: 0
    points:  0
    session_key: null
    session_secret_key: null
    installed: false
    last_visited_at: null
    ep_updated_at: null
    hp_updated_at: null
  }

  @default: ->
    new @(DEFAULT_DB_ATTRIBUTES)

  constructor: ->
    super

    for attribute in ['hp', 'ep']
      @.defineRestorableAttribute(attribute)

  create: ->
    @last_visited_at = @ep_updated_at = @hp_updated_at = new Date()

    super

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

  toJSON: ->
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