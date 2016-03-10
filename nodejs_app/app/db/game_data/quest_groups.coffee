QuestGroup = require("../../game_data").QuestGroup

QuestGroup.define("quest_group_1", (obj)->
  obj.level = 1

  obj.addReward 'collect', (r)->
    r.vipMoney 1
    r.basicMoney 100
)

QuestGroup.define("quest_group_2", (obj)->
  obj.level = 5

  obj.addReward 'collect', (r)->
    r.vipMoney 2
    r.basicMoney 200
)

QuestGroup.define("quest_group_3", (obj)->
  obj.level = 10
)

QuestGroup.define("quest_group_4", (obj)->
  obj.level = 15
)

QuestGroup.define("quest_group_5", (obj)->
  obj.level = 20
)

QuestGroup.define("quest_group_6", (obj)->
  obj.level = 25
)

QuestGroup.define("quest_group_7", (obj)->
  obj.level = 30
)
