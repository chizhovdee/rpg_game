_ = require('lodash')

FULL_REFILL_DURATION = _(12).hours()
HP_RESTORE_DURATION  = _(1).minutes()
EP_RESTORE_DURATION  = _(15).seconds()

module.exports =
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