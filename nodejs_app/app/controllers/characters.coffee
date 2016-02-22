Character = require('../models/character')

exports.gameData = (req, res)->
  Character.fetchForRead(req.db, req.user.id)
  .then((data)->
    character = new Character(data)

    res.sendEvent("character_game_data_loaded", (data)->
      data.character = character.forClient()
    )
  )
  .catch(
    (err)-> res.sendEventError(err)
  )

exports.status = (req, res)->
  Character.fetchForRead(req.db, req.user.id)
  .then((data)->
    character = new Character(data)

    res.sendEvent("character_status_loaded", (data)->
      data.character = character.forClient()
    )
  )
  .catch(
    (err)-> res.sendEventError(err)
  )