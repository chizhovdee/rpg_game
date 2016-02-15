gulp = require("gulp")
fs = require("fs")
ejs = require("ejs")

gulp.task("game_data:populate", ->
  require('require-dir')('../app/db/game_data', recurse: true )

  gameData = {}

  fs.readdirSync("./app/game_data/").forEach((name)->
    if name.indexOf(".coffee") > 0 && name != "base.coffee"
      baseName = name.split(".coffee")[0]

      gameData[baseName] = require("../app/game_data/" + baseName)
  )

  tmpl = fs.readFileSync("./client/populate_game_data.ejs")

  result = ejs.render(tmpl.toString(), data: gameData)

  fs.mkdir('./build', ->
    fs.mkdir('./build/client', ->
      fs.writeFileSync("./build/client/populate_game_data.js", result)
    )
  )
)