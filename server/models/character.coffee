_ = require("underscore")
State = require("./character_state")
db = require("../db/conn")

class Character
  id: null
  level: null
  experience: null
  basic_money: null
  vip_money: null
  state: null

  constructor: (attributes)->
    _.extend(@, attributes) if attributes

  withState: (fields..., callback)->
    db.one("select #{fields.join(', ')} from character_states where character_id = $1", @id)
    .then((data)->
      console.log data

      callback?()
    )
    .error((error)->
      console.error error
    )

  forClient: ->
    id: @id
    level: @level
    restorable_ep: @restorableAttr("ep")
    energy_points: @energy
    restorable_hp: @restorableAttr("hp")
    health_points: @health
    experience: @experience
    basic_money: @basic_money
    vip_money: @vip_money
    hp_restore_in: @.timeToRestore("hp")
    ep_restore_in: @.timeToRestore("ep")

  restorableAttr: (attribute)->
    @[attribute]

  timeToRestore: (attribute)->
    0


module.exports = Character