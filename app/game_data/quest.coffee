_ = require("lodash")
Base = require("./base")
Level = require('./quest_level')

class Quest extends Base
  quest_group_key: null
  levels_count: null

  @configure()

  constructor: ->
    super

    @levels_count = 0

  addLevel: (number, callback)->
    key = @key

    Level.define("quest_#{@key}_level_#{number}", (l)->
      l.quest_key = key
      l.number = number

      callback(l)
    )

    @levels_count += 1

  forClient: ->
    _.assign(
      quest_group_key: @quest_group_key
      levels_count: @levels_count
      ,
      super
    )

module.exports = Quest
