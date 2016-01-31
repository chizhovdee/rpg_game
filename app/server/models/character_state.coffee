_ = require('lodash')

class CharacterState
  quests: null

  constructor: (attributes)->
    _.assignIn(@, attributes) if attributes


module.exports = CharacterState