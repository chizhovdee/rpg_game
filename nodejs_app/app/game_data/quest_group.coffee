_ = require('lodash')
Base = require("./base")

class QuestGroup extends Base
  level: null

  @configure()

  constructor: ->
    Object.defineProperty(@, '_quests', value: [], writable: false)

    Object.defineProperty(@, 'quests'
      enumerable: true
      get: -> @_quests
    )

  addQuest: (quest)->
    _.addUniq(@_quests, quest)

module.exports = QuestGroup