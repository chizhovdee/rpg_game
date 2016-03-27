_ = require('lodash')
Base = require('./base')
QuestsState = require('./quests_state')
ItemsState = require('./items_state')

class CharacterState extends Base
  questsState: ->
    @_questsState ?= new QuestsState(@)

  itemsState: ->
    @_itemsState ?= new ItemsState(@)

module.exports = CharacterState