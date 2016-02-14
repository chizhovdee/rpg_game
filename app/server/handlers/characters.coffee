Character = require('../models/character')

exports.gameData = (req, res)->
  character = null

  Character.fetchForRead(req.db, req.user.id)
  .then((data)->
    character = new Character(data)

    res.eventResponse.add("character_game_data_loaded", (data)->
      data.character = character.forClient()
    )

    res.json(res.eventResponse.all())
  ).catch((err)-> console.error err)


exports.status = (req, res)->
  character = null

  Character.fetchForRead(req.db, req.user.id)
  .then((data)->
    character = new Character(data)

    res.eventResponse.add("character_status_loaded", (data)->
      data.character = character.forClient()
    )

    res.json(res.eventResponse.all())
  ).catch((err)-> console.error err)
