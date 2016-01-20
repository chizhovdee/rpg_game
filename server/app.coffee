express = require('express')
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
fs = require("fs")
promise = require('bluebird')
require("./lib/underscore_mixins").setup()
middleware = require("./middleware")
mixin = require("./mixin")
routes = require('./routes')

do createDbConnection = ->
  pgpOptions = {
    promiseLib: promise
  }

  pgp = require('pg-promise')(pgpOptions)
  mixin.pgp = pgp

  monitor = require('pg-monitor')
  monitor.attach(pgpOptions)
  monitor.setTheme('matrix')

  monitor.log = (msg, info)->
    # save the screen messages into your own log file

  cn = {
    host: 'localhost'
    port: 5432
    database: 'rpg_game_development'
    user: 'deewild'
    password: 'satch'
  }

  db = pgp(cn)
  mixin.db = db

app = express()

# view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs')

publicDir = path.join(__dirname, '../../public') # path from build/server dir

app.use(favicon(path.join(publicDir, 'favicon.ico')));
app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded(extended: false))
app.use(cookieParser())
app.use(express.static(publicDir))

app.use(middleware.getCurrentCharacter)
app.use(middleware.eventResponse)

routes.setup(app)

do defineData = ->
  fs.readdirSync("#{ __dirname }/db/game_data/").forEach((name)->
    if name.indexOf(".js") > 0
      obj = require("#{ __dirname }/db/game_data/#{name}")

      obj.define()
  )

# catch 404 and forward to error handler
app.use((req, res, next)->
  err = new Error('Not Found')
  err.status = 404
  next(err)
)

# error handlers

# development error handler
# will print stacktrace
if app.get('env') == 'development'
  app.use((err, req, res, next)->
    res.status(err.status || 500)

    res.render('error',
      message: err.message
      error: err
    )
  )

# production error handler
# no stacktraces leaked to user
app.use((err, req, res, next)->
  res.status(err.status || 500)

  res.render('error',
    message: err.message,
    error: {}
  )
)

module.exports = app
