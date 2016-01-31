fs = require("fs")
promise = require('bluebird')
path = require("path")

pgpOptions = {
  promiseLib: promise
}

module.exports.setup = ->
  pgp = require('pg-promise')(pgpOptions)

  monitor = require('pg-monitor')
  monitor.attach(pgpOptions)
  monitor.setTheme('matrix')

  monitor.log = (msg, info)->
    # save the screen messages into your own log file

  # в случае проблемы path.resolve('./server', '../config/database.json')
  configPath = path.join(__dirname, '../../config/database.json')

  cn = fs.readFileSync(configPath)

  pgp(JSON.parse(cn).dev)
