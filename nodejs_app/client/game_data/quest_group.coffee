Base = require("./base")

class QuestGroup extends Base
  @configure 'QuestGroup', 'key', 'reward', 'position'

module.exports = QuestGroup