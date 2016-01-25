_ = require("lodash")
Base = require("./base")

class Quest extends Base
  quest_group_key: null

  @configure()

  name: ->
    I18n.t("game_data.quests.#{@key}.name")

  description: ->
    I18n.t("game_data.quests.#{@key}.description")

  forClient: ->
    _.assign(
      quest_group_key: @quest_group_key
      ,
      super
    )

module.exports = Quest
