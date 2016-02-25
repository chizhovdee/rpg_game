express = require('express')
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
fs = require("fs")

Ok = require('./lib/odnoklassniki')
middleware = require('./lib/middleware')

app = express()

# загрузка и инициализации дополнительного функциоанала
boot = require('./boot')
db = boot.setupPostgresqlConnection(app.get('env'))
redis = boot.setupRedisConnection(app.get('env'))

boot.loadGameData()
boot.registerLodashMixins()

# view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs')

# сторонние модули middleware
app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded(extended: false))
app.use(cookieParser())
#app.use(boot.createSession(app.get('env'))) нет пока надобности

# статика
publicDir = path.join(__dirname, '../public')
app.use(favicon(path.join(publicDir, 'favicon.ico')));
app.use(express.static(publicDir))

app.use(Ok.middleware)
app.use(middleware.assignment(db: db, redis: redis))
app.use(middleware.requestParamsLog)
app.use(middleware.eventResponse)
app.use(middleware.currentUser)

app.use((req, res, next)->
  req.user = {id: 1}

  next()
)

require('./routes').setup(app)

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
