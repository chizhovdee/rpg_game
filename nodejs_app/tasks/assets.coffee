gulp = require('gulp')
recursive = require('recursive-readdir')
fs = require('fs')

gulp.task('assets', (cb)->
  assetsTimestamps = {}

  recursive('./public/images', (err, files)->
    throw new Error(err) if err?

    for file in files
      baseDirName = file.split('/')[2]

      timeStamp = fs.statSync(file).mtime.valueOf() / 1000

      if !assetsTimestamps[baseDirName]? || assetsTimestamps[baseDirName] < timeStamp
        assetsTimestamps[baseDirName] = timeStamp

    console.log assetsTimestamps

    cb?()
  )
)