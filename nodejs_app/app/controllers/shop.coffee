_ = require('lodash')
Character = require('../models').Character
CharacterState = require('../models').CharacterState
ItemGroup = require('../game_data').ItemGroup

executor = require('../executors').inventory

module.exports =
  # оставить экшн для группы гемов и спеллов
  index: (req, res)->
    CharacterState.fetchForRead(req.db, character_id: req.currentCharacter.id)
    .then((state)->
      characterState = new CharacterState(state)

      questsState = characterState.questsState()

      data = {}
      res.sendEvent("shop_loaded", data)
    )
    .catch((err)->
      res.sendEventError(err)
    )

  buyItem: (req, res)->
    req.db.tx((t)->
      character = new Character(yield Character.fetchForUpdate(t, id: req.currentCharacter.id))

      character.setState(
        new CharacterState(yield CharacterState.fetchForUpdate(t, character_id: req.currentCharacter.id))
      )

      result = executor.buyItem(
        _.toInteger(req.body.item_id), _.toInteger(req.body.amount), character
      )

      res.addResult(result)

      res.addEvent('item_purchased')

      res.addEventProgress(character)

      res.updateResources(t, character, character.state)
    )
    .then(->
      res.sendEvents()
    )
    .catch((error)->
      res.sendEventError(error)
    )

