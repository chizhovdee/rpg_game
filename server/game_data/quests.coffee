Quest = require("../../common/game_data/quest")

exports.define = ->
  Quest.define("quest_1", (obj)->
    obj.quest_group_key = "quest_group_1"
  )

  Quest.define("quest_2", (obj)->
    obj.quest_group_key = "quest_group_1"
  )

  Quest.define("quest_3", (obj)->
    obj.quest_group_key = "quest_group_1"
  )
