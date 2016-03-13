Base = require("./base")

class QuestGroup extends Base
  @configure 'QuestGroup', 'key', 'reward', 'position', 'level'

  name: ->
    I18n.t("game_data.quest_groups.#{@key}")


module.exports = QuestGroup