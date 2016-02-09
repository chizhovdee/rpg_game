_ = require("lodash")
State = require("./character_state")
QuestsState  = require('./quests_state')

class Character
  FULL_REFILL_DURATION = _(12).hours()
  HP_RESTORE_DURATION  = _(1).minutes()
  EP_RESTORE_DURATION  = _(5).minutes()

  id: null
  level: null
  experience: null
  basic_money: null
  vip_money: null
  state: null
  hp: null
  ep: null
  health: null
  energy: null

  # states
  _quests: null

  constructor: (attributes)->
    _.assignIn(@, attributes) if attributes

  quests: ->
    @_quests ?= new QuestsState(@)

  withState: (db, callback)->
    throw new Error("Character state is already...") if @state

    character = @

    db.one("select * from character_states where character_id = $1", @id)
    .then((data)->
      console.log 'state db', data

      character.state = new State(data)

      callback?()
    )
    .error((error)->
      console.error error
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

    if @["#{attribute}_updated_at"].valueOf() < Date.now() - FULL_REFILL_DURATION
      total
    else
      value = @[attribute] + @.restoresSinceLastUpdate(attribute)

      value = 0 if value < 0

      if value >= total
        total
      else
        value

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
      when "hp"
        @.restorable(attribute) >= @.energyPoints()

  restoreBonus: (attribute)->
    0

  forClient: ->
    id: @id
    level: @level
    restorable_ep: @.restorable("ep")
    energy_points: @.energyPoints()
    restorable_hp: @.restorable("hp")
    health_points: @.healthPoints()
    experience: @experience
    basic_money: @basic_money
    vip_money: @vip_money
    hp_restore_in: @.timeToRestore("hp")
    ep_restore_in: @.timeToRestore("ep")


module.exports = Character