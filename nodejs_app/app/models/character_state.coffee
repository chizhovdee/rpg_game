_ = require('lodash')
Base = require('./base')
QuestsState = require('./quests_state')

class CharacterState extends Base
  questsState: ->
    @_questsState ?= new QuestsState(@)


module.exports = CharacterState