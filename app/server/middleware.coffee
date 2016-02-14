EventResponse = require("./lib/event_response")
Character = require("./models/character")

module.exports =
  eventResponse: (request, response, next)->
    response.eventResponse = new EventResponse()

    next()

#  getCurrentCharacter: (request, response, next)->
#    if request.method == 'GET'
#      Character.fetchForRead(request.db, 1)
#      .then((data)->
#        request.currentCharacter = new Character(data)
#
#        next()
#      )
#      .catch((error)->
#        console.error(error)
#      )
#
#    else
#      request.db.one("select * from characters where id=$1", 1)
#      .then((data)->
#        request.currentCharacter = new Character(data)
#
#        next()
#      )
#      .catch((error)->
#        console.error(error)
#      )