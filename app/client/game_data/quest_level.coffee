BaseGameData = require("../lib/base_game_data")

class QuestLevel extends BaseGameData
  quest_key: null
  number: null
  steps: null

  @configure "QuestLevel", "key", "quest_key", "rewards", "requirements", "number", "steps"


module.exports = QuestLevel