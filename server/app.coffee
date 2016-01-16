express = require('express')
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
fs = require("fs")
middleware = require("./middleware")

routes = require('./routes')
gameData = require('./game_data')

app = express()

# view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs')

# uncomment after placing your favicon in /public
#app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'))
app.use(bodyParser.json())
app.use(bodyParser.urlencoded(extended: false))
app.use(cookieParser())
app.use(express.static('public'))

app.use(middleware.eventResponse)

# setup all routes
routes.setup(app)

# define game data
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
