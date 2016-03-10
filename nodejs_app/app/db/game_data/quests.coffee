require('./quest_groups') # загружаем в первую очередь

Quest = require("../../game_data").Quest

Quest.define("quest_1", (obj)->
  obj.quest_group_key = "quest_group_1"

  obj.addLevel (l)->
    l.steps = 5

    l.addRequirement 'perform', (r)->
      r.energy 1

    l.addReward 'perform', (r)->
      r.experience 5
      r.basicMoney 10

    l.addReward 'complete', (r)->
      r.vipMoney 1
)

Quest.define("quest_2", (obj)->
  obj.quest_group_key = "quest_group_1"

  obj.addLevel (l)->
    l.steps = 6

    l.addRequirement 'perform', (r)->
      r.energy 2

    l.addReward 'perform', (r)->
      r.experience 15
      r.basicMoney 20

    l.addReward 'complete', (r)->
      r.vipMoney 1
)

Quest.define("quest_3", (obj)->
  obj.quest_group_key = "quest_group_1"

  obj.addLevel (l)->
    l.steps = 7

    l.addRequirement 'perform', (r)->
      r.energy 3

    l.addReward 'perform', (r)->
      r.experience 25
      r.basicMoney 30

    l.addReward 'complete', (r)->
      r.vipMoney 1
)
