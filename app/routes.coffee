express = require('express')
passport = require('passport')
boot = require('./boot')
middleware = require('./lib/middleware')

controllers = require('./controllers')

exports.setup = (app, redis)->
  # home
  app.get("/", controllers.home.index)

  # api routes
  do (apiRoutes = express.Router())->
    app.use("/api/:version", apiRoutes)

    apiRoutes.use(boot.createSessionForApi(redis))

    apiRoutes.use(passport.initialize())
    apiRoutes.use(passport.session())

    apiRoutes.use(middleware.apiRequestParamsLog)
    apiRoutes.use(middleware.eventResponse)
    apiRoutes.use(middleware.ensureLogin)

    # characters
    apiRoutes.get("/characters/game_data.json", controllers.characters.gameData)
    apiRoutes.get("/characters/status.json", controllers.characters.status)

    # quests
    apiRoutes.get('/quests.json', controllers.quests.index)
    apiRoutes.put('/quests/perform.json', controllers.quests.perform)

    apiRoutes.post('/login', passport.authenticate('local'),
      (req, res)->
        res.json(['SUCCESS LOGGED', req.user])
    )

  # admin routes
  do (adminRoutes = express.Router())->
    app.use("/admin", adminRoutes)

    adminRoutes.use(passport.authenticate('basic', { session: false }))

    adminRoutes.get('/', (req, res)->
      res.send('admin panel')
    )

    adminRoutes.get('/dashboard', (req, res)->
      res.send('dashboard panel')
    )
