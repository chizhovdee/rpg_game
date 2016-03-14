require('./quest_groups') # загружаем в первую очередь

Quest = require("../../game_data").Quest

Quest.define("quest_1", (obj)->
  obj.questGroupKey = "quest_group_1"

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
  obj.questGroupKey = "quest_group_1"

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
  obj.questGroupKey = "quest_group_1"

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


Quest.define("quest_1_2", (obj)->
  obj.questGroupKey = "quest_group_2"

  for i in [0...2]
    obj.addLevel (l)->
      l.steps = 5 + i

      l.addRequirement 'perform', (r)->
        r.energy 1 + i

      l.addReward 'perform', (r)->
        r.experience 5 + i
        r.basicMoney 10 + i

      l.addReward 'complete', (r)->
        r.vipMoney 1 + i
)


Quest.define("quest_2_2", (obj)->
  obj.questGroupKey = "quest_group_2"

  for i in [0...2]
    obj.addLevel (l)->
      l.steps = 6 + i

      l.addRequirement 'perform', (r)->
        r.energy 2 + i

      l.addReward 'perform', (r)->
        r.experience 6 + i
        r.basicMoney 11 + i

      l.addReward 'complete', (r)->
        r.vipMoney 2 + i
)






