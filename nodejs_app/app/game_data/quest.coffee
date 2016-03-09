_ = require("lodash")
Base = require("./base")
Group = require('./quest_group')
Level = require('./quest_level')

class Quest extends Base
  quest_group_key: null
  levels_count: null

  @configure()

  @afterDefine 'setGroup'

  constructor: ->
    super

    @levels_count = 0

  setGroup: ->
    Object.defineProperty(@, 'group'
      value: Group.find(@quest_group_key)
      writable: false
      enumerable: true
    )

    @group.addQuest(@)

  levelKey: (number)->
    "quest_#{@key}_level_#{number}"

  addLevel: (number, callback)->
    key = @key

    Level.define(@.levelKey(number), (l)->
      l.quest_key = key
      l.number = number

      callback(l)
    )

    @levels_count += 1

  levelByNumber: (nubmer)->
    Level.find(@.levelKey(nubmer))

  forClient: ->
    _.assign(
      quest_group_key: @quest_group_key
      levels_count: @levels_count
      ,
      super
    )

module.exports = Quest
