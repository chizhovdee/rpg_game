Base = require("./base")
_ = require('lodash')

class QuestLevel extends Base
  questKey: null
  steps: null
  number: null

  @configure()

  toJSON: ->
    _.assign(
      quest_key: @questKey
      steps: @steps
      number: @number
      requirements: @requirement
      rewards: @reward
      ,
      super
    )


module.exports = QuestLevel

