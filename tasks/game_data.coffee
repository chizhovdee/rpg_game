gulp = require("gulp")
fs = require("fs")
ejs = require("ejs")

gulp.task("game_data:populate", ->
  require('require-dir')('../db/game_data', recurse: true )

  gameData = {}

  fs.readdirSync("./app/server/game_data/").forEach((name)->
    if name.indexOf(".coffee") > 0 && name != "base.coffee"
      baseName = name.split(".coffee")[0]

      gameData[baseName] = require("../app/server/game_data/" + baseName)
  )

  tmpl = fs.readFileSync("./app/client/populate_game_data.ejs")

  result = ejs.render(tmpl.toString(), data: gameData)

  fs.mkdir('./build', ->
    fs.mkdir('./build/client', ->
      fs.writeFileSync("./build/client/populate_game_data.js", result)
    )
  )
)