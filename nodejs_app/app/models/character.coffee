_ = require("lodash")

class Character
  FULL_REFILL_DURATION = _(12).hours()
  HP_RESTORE_DURATION  = _(1).minutes()
  EP_RESTORE_DURATION  = _(5).minutes()

  DEFAULT_ATTRIBUTES = {
    level: 1
    hp: 100
    health: 100
    energy: 10
    ep: 10
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

  # states
  _quests: null

  @createDefault: ->
    new @(DEFAULT_ATTRIBUTES)

  @fetchBySocialId: (db, social_id)->
    db.oneOrNone("select * from characters where social_id=$1 limit 1", social_id)

  @fetchForRead: (db, user_id)->
    db.one("select * from characters where id=$1", user_id)

  @fetchForUpdate: (db, id)->
    db.one("select * from characters where id=$1 for update", id)

  constructor: (attributes)->
    _.assignIn(@, attributes) if attributes

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

#  setState: (data)->
#    new State(data)




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