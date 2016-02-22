fs = require("fs")
promise = require('bluebird')
path = require("path")
Redis = require('ioredis')
session = require('express-session')

AUTHORIZED_USERS_KEY = 'authorized_users'

addUserToRedis = (redis, user)->
  redis.hset(AUTHORIZED_USERS_KEY, user.id, JSON.stringify(user))
  redis.expire(AUTHORIZED_USERS_KEY, 1000) # 1000 seconds

module.exports =
  setupPostgresqlConnection: ->
    pgpOptions = {
      promiseLib: promise
    }

    pgp = require('pg-promise')(pgpOptions)

    monitor = require('pg-monitor')
    monitor.attach(pgpOptions)
    monitor.setTheme('matrix')

    monitor.log = (msg, info)->
      # save the screen messages into your own log file

    # в случае проблемы path.resolve('./server', '../config/database.json')
    configPath = path.join(__dirname, '../config/database.json')

    cn = fs.readFileSync(configPath)

    pgp(JSON.parse(cn).dev)

  setupRedisConnection: ->
    redis = new Redis()

    redis.monitor((err, monitor)->
      monitor.on('monitor', (time, args)-> console.log 'Redis:', args, 'time -', time)
    )

    redis

  loadGameData: ->
    require('require-dir')('./db/game_data', recurse: true )

  registerLodashMixins: ->
    require("./lib/lodash_mixin").register()

  createSession: ->
    session(
      secret: "91f37227fa77d78001ba5be1469d0d0d1cbbc60ebb1e4b65eeba3588268a13d1e79f9e9999b9968af04234b3dd17367d2a84b4a7b0372be8ffbf55459c564061"
      resave: false
      saveUninitialized: false
      cookie:
        path: '/'
    )
