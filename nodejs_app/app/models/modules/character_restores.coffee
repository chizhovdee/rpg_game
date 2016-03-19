_ = require('lodash')

FULL_REFILL_DURATION = _(12).hours()
HP_RESTORE_DURATION  = _(1).minutes()
EP_RESTORE_DURATION  = _(30).seconds()

module.exports =
  defineRestorableAttribute: (attribute)->
    Object.defineProperty(@, attribute,
      enumerable: true
      get: -> @.restorable(attribute)
      set: (newValue)->
        return if @.restorable(attribute) == newValue

        @changes[attribute] = [@["_#{ attribute }"], newValue] # [old, new]

        @["_#{ attribute }"] = newValue

        @["#{attribute}_updated_at"] = new Date()

        _.addUniq(@changed, attribute)

        @isChanged = true

        @["_#{ attribute }"] # return new value
    ) if @["_#{ attribute }"]?


  restorable: (attribute)->
    switch attribute
      when "hp"
        total = @.healthPoints()
      when "ep"
        total = @.energyPoints()

    if @["_#{ attribute }"] >= total
      total

    else if @["#{attribute}_updated_at"].valueOf() < Date.now() - FULL_REFILL_DURATION
      total
    else
      value = @["_#{ attribute }"] + @.restoresSinceLastUpdate(attribute)

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