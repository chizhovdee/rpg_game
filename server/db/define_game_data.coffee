path = require("path")
fs = require("fs")

module.exports = ->
  fs.readdirSync(path.join(__dirname, "game_data")).forEach((name)->
    if name.indexOf(".js") > 0 || name.indexOf(".coffee") > 0
      obj = require(path.join(__dirname, "game_data", name))

      obj.define()
  )