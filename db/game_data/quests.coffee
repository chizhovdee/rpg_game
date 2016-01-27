Quest = require("../../app/server/game_data/quest")

Quest.define("quest_1", (obj)->
  obj.quest_group_key = "quest_group_1"

  obj.addRequirement (r)->
    r.energy 1

  obj.addReward (r)->
    r.experience 5
    r.basicMoney 10
)

Quest.define("quest_2", (obj)->
  obj.quest_group_key = "quest_group_1"

  obj.addRequirement (r)->
    r.energy 2

  obj.addReward (r)->
    r.experience 15
    r.basicMoney 15
)

Quest.define("quest_3", (obj)->
  obj.quest_group_key = "quest_group_1"

  obj.addRequirement (r)->
    r.energy 3

  obj.addReward (r)->
    r.experience 15
    r.basicMoney 25
)

Quest.define("quest_4", (obj)->
  obj.quest_group_key = "quest_group_1"
)

Quest.define("quest_5", (obj)->
  obj.quest_group_key = "quest_group_1"
)

Quest.define("quest_6", (obj)->
  obj.quest_group_key = "quest_group_1"
)

Quest.define("quest_7", (obj)->
  obj.quest_group_key = "quest_group_1"
)

Quest.define("quest_8", (obj)->
  obj.quest_group_key = "quest_group_1"
)

