_ = require('lodash')
QuestsState = require('./quests_state')

class CharacterState
  quests: null # db field

  @fetchForRead: (db, character_id)->
    db.one("select * from character_states where character_id = $1", character_id)

  @fetchForUpdate: (db, character_id)->
    db.one("select * from character_states where character_id = $1 for update", character_id)

  constructor: (attributes)->
    _.assignIn(@, attributes) if attributes

  setCharacter: (character)->
    Object.defineProperty(@, 'character'
      value: character
      configurable: false
      enumerable: true
      writable: false
    )

  getQuests: ->
    @_quests ?= new QuestsState(@)


module.exports = CharacterState