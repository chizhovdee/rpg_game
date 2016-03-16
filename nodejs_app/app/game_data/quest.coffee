_ = require("lodash")
Base = require("./base")
Group = require('./quest_group')
Level = require('./quest_level')

class Quest extends Base
  questGroupKey: null
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
      value: Group.find(@questGroupKey)
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
      l.questKey = key
      l.number = number

      callback(l)
    )

    @levels.push(level)
    @levelsCount = @levels.length

  levelByNumber: (nubmer)->
    Level.find(@.levelKey(nubmer))

  levelNumberIsLast: (number)->
    _.last(@levels).number == number

  toJSON: ->
    _.assign(
      quest_group_key: @questGroupKey
      levels_count: @levelsCount
      ,
      super
    )

module.exports = Quest
