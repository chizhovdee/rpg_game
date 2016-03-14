EventResponse = require('../event_response')

module.exports = (req, res, next)->
  res.eventResponse ?= new EventResponse()

  res.addEvent = (type, callback)->
    @eventResponse.add(type, callback)

  res.sendEvents = ->
    @.json(@eventResponse.all())

    null

  res.sendEvent = (type, callback)->
    @.addEvent(type, callback)

    @.sendEvents()

    null

  res.sendEventError = (error, type = '')->
    type = 'server_error' if type == ''

    console.error(error.stack)

    @addEvent(type, error: error.message)

    @.sendEvents()

    null

  res.addEventProgress = (character)->
    @addEvent('character_updated', character.toJSON())

  next()
