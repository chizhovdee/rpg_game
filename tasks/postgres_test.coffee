gulp = require("gulp")
promise = require('bluebird')

Character = require("../server/models/character")

options = {
  promiseLib: promise
}

pgp = require('pg-promise')(options)

cn = {
  host: 'localhost'
  port: 5432
  database: 'rpg_game_development'
  user: 'deewild'
  password: 'satch'
}

db = pgp(cn)

gulp.task("query", ->
  ch1 = null
  ch2 = null

  db.task((t)->
    yield Character.find(t, 1)
    yield Character.find(t, 1)
    yield Character.find(t, 1)

  )
  .then((data)->
    console.log "data", data
  )
  .catch((error)->
    console.log "error", error
  )
  .finally(->
    console.log "Finally block"
    pgp.end()
  )
)
