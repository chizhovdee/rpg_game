EventResponse = require("./lib/event_response")
Character = require("./models/character")

module.exports =
  eventResponse: (request, response, next)->
    response.eventResponse = new EventResponse()

    next()

  getCurrentCharacter: (request, response, next)->
    request.db.one("select * from characters where id=$1", 1)
    .then((data)->
      request.currentCharacter = new Character(data)

      next()
    )
    .error((error)->
      console.error(error)
    )


