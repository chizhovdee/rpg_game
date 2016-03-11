Base = require("./base")
Level = require('./quest_level')

class Quest extends Base
  levels_count: null

  @configure "Quest", "key", "quest_group_key", "levels_count"

  name: ->
    I18n.t("game_data.quests.#{@key}.name")

  description: ->
    I18n.t("game_data.quests.#{@key}.description")

  levels: ->
    @_levels ?= Level.findAllByAttribute('quest_key', @key)

  levelByNumber: (number)->
    _.find(@.levels(), (l)-> l.number == number)

  lastLevel: ->
    _.find(@.levels(), (l)=> l.number == @levels_count)


module.exports = Quest