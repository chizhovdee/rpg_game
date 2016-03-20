Character = require('../models/character')
_ = require('lodash')

executor = require('../executors').characters

module.exports =
  gameData: (req, res)->
    Character.fetchForRead(req.db, id: req.currentCharacter.id)
    .then((data)->
      character = new Character(data)

      res.sendEvent("character_game_data_loaded", (data)->
        data.character = character.toJSON()
      )
    )
    .catch(
      (err)-> res.sendEventError(err)
    )

  status: (req, res)->
    Character.fetchForRead(req.db, id: req.currentCharacter.id)
    .then((data)->
      character = new Character(data)

      res.sendEvent("character_status_loaded", (data)->
        data.character = character.toJSON()
      )
    )
    .catch(
      (err)-> res.sendEventError(err)
    )

  upgrade: (req, res)->
    req.db.tx((t)->
      character = new Character(yield Character.fetchForUpdate(t, id: req.currentCharacter.id))

      params = _.parseRequestParams(req.body, parse_values: true)

      result = executor.upgrade(character, params.operations)

      res.addResult(result)

      res.addEvent('character_upgraded')

      res.addEventProgress(character)

      res.updateResources(t, character)
    )
    .then(->
      res.sendEvents()
    )
    .catch((error)->
      res.sendEventError(error)
    )

