_ = require('lodash')
Base = require("./base")

class QuestGroup extends Base
  level: null
  _quests: null

  @configure()

  constructor: ->
    @_quests = []

    Object.defineProperty(@, 'quests'
      get: -> @_quests
    )

  addQuest: (quest)->
    _.addUniq(@_quests, quest)

module.exports = QuestGroup