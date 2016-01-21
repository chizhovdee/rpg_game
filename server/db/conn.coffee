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

configPath = path.resolve('./server', '../config/database.json')

cn = fs.readFileSync(configPath) # from build

db = pgp(JSON.parse(cn).dev)

console.log "Create database connection"

module.exports = db
