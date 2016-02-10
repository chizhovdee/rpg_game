_ = require('lodash')

class CharacterState
  quests: null

  @fetchForRead: (db, character_id)->
    db.one("select * from character_states where character_id = $1", character_id)

  @fetchForUpdate: (db, character_id)->
    db.one("select * from character_states where character_id = $1 for update", character_id)

  constructor: (attributes)->
    _.assignIn(@, attributes) if attributes


module.exports = CharacterState