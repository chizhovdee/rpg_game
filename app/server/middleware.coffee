EventResponse = require("./lib/event_response")
Character = require("./models/character")

module.exports =
  eventResponse: (request, response, next)->
    response.eventResponse = new EventResponse()

    next()

  getCurrentCharacter: (request, response, next)->
    forUpdate = if request.xhr then 'for update' else ''

    transaction = -> @.one("select * from characters where id=$1 #{forUpdate}", 1)
    transaction.txMode = request.tmS if request.xhr

    request.db.tx(transaction)
    .then((data)->
      request.currentCharacter = new Character(data)

      next()
    )
    .error((error)->
      console.error(error)
    )


