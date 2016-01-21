exports.gameData = (req, res)->
  res.eventResponse.add("character_game_data_loaded", (data)->
    data.character = req.currentCharacter.forClient()
  )

  res.json(res.eventResponse.all())

exports.status = (req, res)->
  res.eventResponse.add("character_status_loaded", (data)->
    data.character = req.currentCharacter.forClient()
  )

  res.json(res.eventResponse.all())