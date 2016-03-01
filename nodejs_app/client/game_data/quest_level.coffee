Base = require("./base")

class QuestLevel extends Base
  quest_key: null
  number: null
  steps: null

  @configure "QuestLevel", "key", "quest_key", "rewards", "requirements", "number", "steps"

  progress: (steps)->
    _.floor(steps / @steps * 100)

module.exports = QuestLevel