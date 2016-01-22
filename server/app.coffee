express = require('express')
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
fs = require("fs")
require("./lib/lodash_mixin").setup()
middleware = require("./middleware")
routes = require('./routes')
do require("./db/define_game_data")

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
