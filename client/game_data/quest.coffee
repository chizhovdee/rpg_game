BaseGameData = require("../lib/base_game_data")

class Quest extends BaseGameData
  @configure "Quest", "key", "quest_group_key"

  name: ->
    I18n.t("game_data.quests.#{@key}.name")

  description: ->
    I18n.t("game_data.quests.#{@key}.description")


module.exports = Quest