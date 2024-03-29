_ = require("lodash")
Base = require('./base')

class Character extends Base
  @include require('./modules/character_restores')
  @include require('./modules/character_experience')

  @UPGRADE_RATES: {
    energy: 1
    health: 10
    attack: 1
    defense: 1
  }

  DEFAULT_DB_ATTRIBUTES = {
    level: 1
    hp: 100
    health: 100
    energy: 20
    ep: 20
    attack: 1
    defense: 1
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
    social_id: null
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

  checkProgress: ->
    if @.levelByCurrentExperience() > @level
      @level += 1
      @points += 5 # TODO balance

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

  upgrade: (operations)->
    points = 0

    for attribute, value of operations
      points += value

      value = @constructor.UPGRADE_RATES[attribute] * value

      @[attribute] += value

      if attribute == 'health'
        @hp += value
      else if attribute == 'energy'
        @ep += value

    @points -= points

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
    experience_to_next_level: @.experienceToNextLevel()
    level_progress_percentage: @.levelProgressPercentage()
    points: @points
    attack: @attack
    defense: @defense


module.exports = Character