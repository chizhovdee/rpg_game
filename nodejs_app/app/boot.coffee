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
  setupPostgresqlConnection: (environment)->
    pgpOptions = {
      promiseLib: promise
    }

    pgp = require('pg-promise')(pgpOptions)

    monitor = require('pg-monitor')
    monitor.attach(pgpOptions)
    monitor.setTheme('matrix')

    monitor.log = (msg, info)->
      # save the screen messages into your own log file

    pgp(@.loadConfig('database.json')[environment])

  setupRedisConnection: (environment)->
    redis = new Redis(@.loadConfig('redis.json')[environment])

    redis.monitor((err, monitor)->
      monitor.on('monitor', (time, args)-> console.log 'Redis:', args, 'time -', time)
    )

    redis

  loadGameData: ->
    require('require-dir')('./db/game_data', recurse: true )

  registerLodashMixins: ->
    require("./lib/lodash_mixin").register()

  createSession: (environment)->
    session(
      secret: @.loadConfig('secrets.json')[environment].secret_key_base
      resave: false
      saveUninitialized: false
      cookie:
        path: '/'
    )

  loadConfig: (file_name)->
    configPath = path.join(__dirname, '../config/', file_name)

    cn = fs.readFileSync(configPath)

    JSON.parse(cn)
