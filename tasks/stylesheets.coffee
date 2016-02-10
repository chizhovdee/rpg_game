gulp = require("gulp")
sass = require('gulp-sass')
notify = require('gulp-notify')
include = require('gulp-include')
gulpif = require('gulp-if')
fs = require("fs")

gulp.task("stylesheets", ['sass-compile'], ->
  gulp.src("./build/stylesheets/application.css")
  .pipe(gulp.dest("./public/stylesheets"))
)

gulp.task('sass-compile', ->
  gulp.src('./app/client/styles/application.scss')
  .pipe(include())
  .pipe(gulpif('application.scss', sass()))
  .on('error', notify.onError(
      title: "SASS ERROR"
      message: "Look in the console for details.\n <%= error.message %>"
    ))
  .pipe(gulpif('application.css',gulp.dest('./build/stylesheets')))
)

gulp.task('bourbon-include', ->
  result = ""

  content = fs.readFileSync("./app/client/styles/bourbon/_bourbon.scss")

  content.toString().split('\n').forEach((str)->
    if str.charAt(0) == '@'
      console.log(str.split("@import")[1].split("\"")[1])

      str = str.split("@import")[1].split("\"")[1]
      dir = str.split("/")[0]
      file = str.split("/")[1]

      if file
        path = dir + "/_" + file + ".scss\n"
      else
        path = "_" + dir + ".scss\n"

      result += "//=require " + path
  )

  fs.writeFileSync("./app/client/styles/bourbon/_bourbon_test.scss", result)
)
