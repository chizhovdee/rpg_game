EventResponse = require("./lib/event_response")
mixin = require("./mixin")

Character = require("./models/character")

module.exports.eventResponse = (request, response, next)->
  response.eventResponse = new EventResponse()

  next()

module.exports.getCurrentCharacter = (request, response, next)->
  console.log "Character URL", request.url

  mixin.db.one("select * from characters where id=$1", 1)
  .then((data)->
    request.currentCharacter = new Character(data)

    next()
  )
  .error((error)->
    console.error(error)
  )


