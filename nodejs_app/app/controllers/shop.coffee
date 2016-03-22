_ = require('lodash')
CharacterState = require('../models').CharacterState
ItemGroup = require('../game_data').ItemGroup

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
