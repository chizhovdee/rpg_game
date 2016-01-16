class EventResponse
  events: null
  constructor: ->
    @events = []

  add: (eventType, callback)->
    data = {}

    callback?(data)

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