Base = require("./base")
_ = require('lodash')

class QuestLevel extends Base
  quest_key: null
  steps: null
  number: null

  @configure()

  forClient: ->
    _.assign(
      quest_key: @quest_key
      steps: @steps
      number: @number
      requirements: @requirement?.forClient()
      rewards: @reward?.forClient()
      ,
      super
    )


module.exports = QuestLevel

