EventResponse = require('../event_response')

module.exports = (req, res, next)->
  res.eventResponse ?= new EventResponse()

  res.addEvent = (type, callback)->
    @eventResponse.add(type, callback)

  res.sendEvents = ->
    @.json(@eventResponse.all())

  res.sendEvent = (type, callback)->
    @.addEvent(type, callback)

    @.sendEvents()

  res.sendEventError = (error, type = '')->
    type = 'server_error' if type == ''

    @eventResponse.add(type, (data)->
      data.error = error
    )

    @.sendEvents()

  next()
