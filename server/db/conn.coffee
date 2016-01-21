fs = require("fs")
promise = require('bluebird')
path = require("path")

pgpOptions = {
  promiseLib: promise
}

pgp = require('pg-promise')(pgpOptions)

monitor = require('pg-monitor')
monitor.attach(pgpOptions)
monitor.setTheme('matrix')

monitor.log = (msg, info)->
  # save the screen messages into your own log file

cn = fs.readFileSync(path.join(__dirname, "../../../config/database.json")) # from build

db = pgp(JSON.parse(cn).dev)

console.log "connect to database"

module.exports = db
