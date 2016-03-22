gulp = require("gulp")
fs = require("fs")
ejs = require("ejs")

gulp.task("game_data:populate", ->
  # удаляем сначала из кэша
  fs.readdirSync("./app/db/game_data/").forEach((name)->
    stats = fs.statSync("./app/db/game_data/#{name}")

    if stats.isFile()
      delete require.cache[require.resolve("../app/db/game_data/#{name}")]

    if stats.isDirectory()
      throw Error('is directory: Change logic in game_data:populate task')
  )

  fs.readdirSync("./app/game_data/").forEach((name)->
    delete require.cache[require.resolve("../app/game_data/#{name}")]
  )

  require('require-dir')('../app/db/game_data', recurse: true )

  gameData = {}

  fs.readdirSync("./app/game_data/").forEach((name)->
    if name.indexOf(".coffee") > 0 && name not in ["base.coffee", 'index.coffee']
      baseName = name.split(".coffee")[0]

      resource = require("../app/game_data/" + baseName)

      gameData[baseName] = resource if resource.isPublicForClient()
  )

  tmpl = fs.readFileSync("./client/populate_game_data.ejs")

  result = ejs.render(tmpl.toString(), data: gameData)

  fs.mkdir('./build', ->
    fs.mkdir('./build/client', ->
      fs.writeFileSync("./build/client/populate_game_data.js", result)
    )
  )
)