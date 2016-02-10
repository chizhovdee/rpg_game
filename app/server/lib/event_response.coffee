_ = require('lodash')

class EventResponse
  events: null
  constructor: ->
    @events = []

  add: (eventType, callbackOrData)->
    data = {}

    if _.isFunction(callbackOrData)
      callbackOrData?(data)
    else
      data = callbackOrData

    @events.push(
      event_type: eventType
      data: data
    )

  all: ->
    @events

  allWithProgress: (request)->
    # TODO
    # метод для отдачи всех событий вместе с прогрессом персонажа


module.exports = EventResponse