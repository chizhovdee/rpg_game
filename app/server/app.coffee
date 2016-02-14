express = require('express')
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')

fs = require("fs")

passport = require('passport')
LocalStrategy = require('passport-local').Strategy
BasicStrategy = require('passport-http').BasicStrategy

require("./lib/lodash_mixin").register()
db = require('./db').setup()

Redis = require('ioredis')
redis = new Redis()

redis.monitor((err, monitor)->
  monitor.on('monitor', (time, args)-> console.log 'Redis:', args, 'time -', time)
)

middleware = require("./middleware")
routes = require('./routes')

require('require-dir')('./db/game_data', recurse: true )

app = express()

# view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs')

publicDir = path.join(__dirname, '../../public')

app.use(favicon(path.join(publicDir, 'favicon.ico')));
app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded(extended: false))
app.use(cookieParser())

app.use(express.static(publicDir))

app.use((req, res, next)->
  req.db = db.db
  req.redis = redis

  next()
)

app.use(middleware.eventResponse)

routes.setup(app, redis)

passport.use(new LocalStrategy((login, password, done)->
  console.log 'local strategy'

  db.db.one("select * from users where login=$1 and password=$2", [login, password])
  .then((user)->
    if user
      done null, user
    else
      done null, false
  )
  .catch((err)-> done err)
))

passport.use(new BasicStrategy((login, password, done)->
  console.log 'basic strategy'

  db.db.one("select * from users where login=$1 and password=$2 and admin=true", [login, password])
  .then((user)->
    if user
      done null, user
    else
      done null, false
  )
  .catch((err)-> done err)
))

passport.serializeUser((user, done)->
  console.log 'serializeUser'
  done null, user.id
)


passport.deserializeUser((id, done)->
  console.log "deserializeUser"
  db.db.one("select * from users where id=$1", [id])
  .then((user)->
    done null, user
  )
  .catch((err)-> done err)
)

# catch 404 and forward to error handler
app.use((req, res, next)->
  err = new Error('Page not Found')
  err.status = 404
  next(err)
)

# error handlers

# development error handler
# will print stacktrace
if app.get('env') == 'development'
  app.use((err, req, res, next)->
    res.status(err.status || 500)

    console.error err.stack

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
