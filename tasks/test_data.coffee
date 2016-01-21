gulp = require("gulp")
promise = require('bluebird')

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

gulp.task("create_character", ->
  db.one("""insert into characters(energy, ep, hp, health, basic_money, vip_money)
		                        values($1, $2, $3, $4, $5, $6) returning id""",
                                  [10, 10, 100, 100, 100, 1]
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