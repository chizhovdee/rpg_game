EventResponse = require("./lib/event_response")

module.exports.eventResponse = (request, response, next)->
  response.eventResponse = new EventResponse()

  next()
