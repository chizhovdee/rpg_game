_ = require("lodash")
Base = require("./base")
Group = require('./quest_group')
Level = require('./quest_level')

class Quest extends Base
  quest_group_key: null
  levelsCount: null

  @configure()

  @afterDefine 'setGroup'

  constructor: ->
    super

    @levelsCount = 0

    Object.defineProperties(@,
      _levels: {
        value: []
        writable: false
      }

      levels: {
        enumerable: true
        get: -> @_levels
      }
    )

  setGroup: ->
    Object.defineProperty(@, 'group'
      value: Group.find(@quest_group_key)
      writable: false
      enumerable: true
    )

    @group.addQuest(@)

  levelKey: (number)->
    "quest_#{@key}_level_#{number}"

  addLevel: (callback)->
    key = @key

    number = @levels.length + 1

    level = Level.define(@.levelKey(number), (l)->
      l.quest_key = key
      l.number = number

      callback(l)
    )

    @levels.push(level)
    @levelsCount = @levels.length

  levelByNumber: (nubmer)->
    Level.find(@.levelKey(nubmer))

  levelNumberIsLast: (number)->
    _.last(@levels).number == number

  forClient: ->
    _.assign(
      quest_group_key: @quest_group_key
      levels_count: @levelsCount
      ,
      super
    )

module.exports = Quest
