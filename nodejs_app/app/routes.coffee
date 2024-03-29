express = require('express')
middleware = require('./lib/middleware')
controllers = require('./controllers')

exports.setup = (app)->
  # home
  app.get("/", controllers.home.index)

  # api routes
  do (apiRoutes = express.Router())->
    app.use("/api/:version", apiRoutes)

    # characters
    apiRoutes.get("/characters/game_data.json", controllers.characters.gameData)
    apiRoutes.get("/characters/status.json", controllers.characters.status)
    apiRoutes.put('/characters/upgrade.json', controllers.characters.upgrade)

    # quests
    apiRoutes.get('/quests.json', controllers.quests.index)
    apiRoutes.put('/quests/perform.json', controllers.quests.perform)
    apiRoutes.put('/quests/complete_group.json', controllers.quests.completeGroup)

    # shop
    #apiRoutes.get('/shop.json', controllers.shop.index)
    apiRoutes.post('/buy_item.json', controllers.shop.buyItem)
