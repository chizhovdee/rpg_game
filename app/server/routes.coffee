express = require('express')

session = require('express-session')
RedisStore = require('connect-redis')(session)
passport = require('passport')

home = require("./handlers/home")
characters = require("./handlers/characters")
quests = require('./handlers/quests')

exports.setup = (app, redis)->
  # home
  app.get("/", home.index)

  # api routes
  apiRoutes = express.Router()
  app.use("/api/:version", apiRoutes)

  apiRoutes.use(session(
    store: new RedisStore(client: redis)
    secret: "777"
    resave: false
    saveUninitialized: false
    cookie:
      path: '/api/'
  ))

  apiRoutes.use(passport.initialize())
  apiRoutes.use(passport.session())
  apiRoutes.use((req, res, next)->
    console.log "User", req.user

    console.log 'Path from API', req.path

    if req.user || req.path == '/login'
      next()

    else
      res.json('NOT LOGGED')
  )


  # characters
  apiRoutes.get("/characters/game_data.json", characters.gameData)
  apiRoutes.get("/characters/status.json", characters.status)

  # quests
  apiRoutes.get('/quests.json', quests.index)
  apiRoutes.put('/quests/perform.json', quests.perform)

  apiRoutes.post('/login',
    passport.authenticate('local'),
    (req, res)->
      console.log req.body
      console.log req.params

      res.json(['SUCCESS LOGGED', req.user])
  )


  adminRoutes = express.Router()
  app.use("/admin", adminRoutes)

  adminRoutes.use(passport.authenticate('basic', { session: false }))

  adminRoutes.get('/', (req, res)->
    res.send('admin panel')
  )

  adminRoutes.get('/dashboard', (req, res)->
    res.send('dashboard panel')
  )
