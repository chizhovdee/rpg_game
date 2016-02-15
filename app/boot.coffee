fs = require("fs")
promise = require('bluebird')
path = require("path")
Redis = require('ioredis')
passport = require('passport')
LocalStrategy = require('passport-local').Strategy
BasicStrategy = require('passport-http').BasicStrategy
session = require('express-session')
RedisStore = require('connect-redis')(session)

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

  setupPassport: (db, redis)->
    passport.use(new LocalStrategy((login, password, done)->
      console.log 'passport local strategy'

      db.one("select id, login, password from characters where login=$1 and password=$2", [login, password])
      .then((user)->
        if user
          addUserToRedis(redis, user)

          done(null, user)
        else
          done(null, false)
      )
      .catch((err)->
        done(err)
      )
    ))

    passport.use(new BasicStrategy((login, password, done)->
      console.log 'passport basic strategy'

      db.one("select * from characters where login=$1 and password=$2 and admin=true", [login, password])
      .then((user)->
        if user
          done(null, user)
        else
          done(null, false)
      )
      .catch((err)->
        done(err)
      )
    ))

    passport.serializeUser((user, done)->
      console.log 'passport serializeUser'
      done(null, user.id)
    )

    passport.deserializeUser((id, done)->
      console.log "passport deserializeUser"

      redis.hget(AUTHORIZED_USERS_KEY, id, (err, user)->
        if err
          done(err)

        else if user
          done(null, JSON.parse(user))

        else
          db.one("select id, login, password from characters where id=$1", [id])
          .then((user)->
            if user
              addUserToRedis(redis, user)

              done(null, user)
            else
              done(null, false)
          )
          .catch((err)->
            done(err)
          )
      )
    )

  loadGameData: ->
    require('require-dir')('./db/game_data', recurse: true )

  registerLodashMixins: ->
    require("./lib/lodash_mixin").register()

  createSessionForApi: (redis)->
    session(
      store: new RedisStore(client: redis)
      secret: "777"
      resave: false
      saveUninitialized: false
      cookie:
        path: '/api/'
    )
