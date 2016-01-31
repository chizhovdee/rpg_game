Quest = require("../../game_data/quest")

Quest.define("quest_1", (obj)->
  obj.quest_group_key = "quest_group_1"

  for number in [1..4]
    obj.addLevel number, (l)->
      l.addRequirement (r)->
        r.energy 1 * number

      l.addReward (r)->
        r.experience 5 * number
        r.basicMoney 10 * number
)

Quest.define("quest_2", (obj)->
  obj.quest_group_key = "quest_group_1"

  obj.addLevel 1, (l)->
    l.addRequirement (r)->
      r.energy 2

    l.addReward (r)->
      r.experience 15
      r.basicMoney 20
)

Quest.define("quest_3", (obj)->
  obj.quest_group_key = "quest_group_1"

  obj.addLevel 1, (l)->
    l.addRequirement (r)->
      r.energy 3

    l.addReward (r)->
      r.experience 25
      r.basicMoney 30
)

Quest.define("quest_4", (obj)->
  obj.quest_group_key = "quest_group_1"

  obj.addLevel 1, (l)->
    l.addRequirement (r)->
      r.energy 4

    l.addReward (r)->
      r.experience 35
      r.basicMoney 40
)