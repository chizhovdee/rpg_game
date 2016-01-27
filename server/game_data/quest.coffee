_ = require("lodash")
Base = require("./base")

class Quest extends Base
  quest_group_key: null

  @configure()

  forClient: ->
    _.assign(
      quest_group_key: @quest_group_key
      requirements: @requirement?.forClient()
      rewards: @reward?.forClient()
      ,
      super
    )

module.exports = Quest
