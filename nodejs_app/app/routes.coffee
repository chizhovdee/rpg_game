express = require('express')
middleware = require('./lib/middleware')

controllers = require('./controllers')

exports.setup = (app)->
  # home
  app.get("/", controllers.home.index)

  # api routes
  do (apiRoutes = express.Router())->
    app.use("/api/:version", apiRoutes)

    apiRoutes.use(middleware.apiRequestParamsLog)
    apiRoutes.use(middleware.eventResponse)

    # characters
    apiRoutes.get("/characters/game_data.json", controllers.characters.gameData)
    apiRoutes.get("/characters/status.json", controllers.characters.status)

    # quests
    apiRoutes.get('/quests.json', controllers.quests.index)
    apiRoutes.put('/quests/perform.json', controllers.quests.perform)