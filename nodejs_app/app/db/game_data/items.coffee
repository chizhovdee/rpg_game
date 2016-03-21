Item = require('../../game_data').Item

Item.define('armor_1', (obj)->
  obj.itemGroupKey = 'armor'

  obj.effects = {attack: 1}

  obj.level = 1

  obj.basicPrice = 10
)

Item.define('armor_2', (obj)->
  obj.itemGroupKey = 'armor'

  obj.effects = {attack: 2}

  obj.level = 2

  obj.vipPrice = 1
)

Item.define('boost_1', (obj)->
  obj.itemGroupKey = 'boosts'

  obj.effects = {damage: 1}

  obj.level = 2

  obj.basicPrice = 20
  obj.vipPrice = 2
)

Item.define('potion_1', (obj)->
  obj.itemGroupKey = 'potions'

  obj.basicPrice = 100

  obj.level = 2

  obj.addReward 'use', (r)->
    r.energy 5
    r.health 20
)