express = require('express')
home = require("./handlers/home")
characters = require("./handlers/characters")

exports.setup = (app)->
  # home
  app.get("/", home.index)

  # api routes
  apiRoutes = express.Router()
  app.use("/api/:version", apiRoutes)

  # characters
  apiRoutes.get("/characters/game_data.json", characters.gameData)
  apiRoutes.get("/characters/status.json", characters.status)