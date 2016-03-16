_ = require('lodash')
Base = require("./base")

class QuestGroup extends Base
  level: null

  @configure()
  @afterDefine 'setPosition'

  constructor: ->
    Object.defineProperty(@, '_quests', value: [], writable: false)

    Object.defineProperty(@, 'quests'
      enumerable: true
      get: -> @_quests
    )

  addQuest: (quest)->
    _.addUniq(@_quests, quest)

  setPosition: ->
    Object.defineProperty(@, 'position', value: QuestGroup.count - 1, writable: false)

  toJSON: ->
    _.assign(
      reward: @reward
      position: @position
      level: @level
      ,
      super
    )

module.exports = QuestGroup