gulp = require('gulp')
recursive = require('recursive-readdir')
fs = require('fs')
ejs = require("ejs")

gulp.task('assets-timestamps', (cb)->
  assetsTimestamps = {}

  recursive('./public/images', (err, files)->
    throw new Error(err) if err?

    for file in files
      baseDirName = file.split('/')[2]

      timeStamp = fs.statSync(file).mtime.valueOf() / 1000

      if !assetsTimestamps[baseDirName]? || assetsTimestamps[baseDirName] < timeStamp
        assetsTimestamps[baseDirName] = timeStamp


    tmpl = fs.readFileSync("./client/assets_timestamps.ejs")

    result = ejs.render(tmpl.toString(), assetsTimestamps: assetsTimestamps)

    fs.mkdir('./build', ->
      fs.mkdir('./build/client', ->
        fs.writeFileSync("./build/client/assets_timestamps.js", result)
      )
    )

    cb?()
  )
)