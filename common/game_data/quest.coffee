_ = require("lodash")

Base = require("./base")

class Quest extends Base
  @configure()

  quest_group_key: null

  forClient: ->
    _.assign(
      quest_group_key: @quest_group_key
      ,
      super
    )

module.exports = Quest
