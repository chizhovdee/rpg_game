gulp = require("gulp")
eco = require('gulp-eco')
concat = require('gulp-concat')
browserify = require('browserify')
file = require('gulp-file')
notify = require('gulp-notify')

eco_files_path = "./client/views/**/*.eco"
compiled_eco_js = "JST.js"
build_path = "./build/client/"

gulp.task("eco-compile", ->
  gulp.src(eco_files_path)
  .pipe(eco({nameExport: "module.exports", basePath: 'client/views'}))
  .on('error', notify.onError({
      title: "ECO templates ERROR",
      message: "Look in the console for details.\n <%= error.message %>"
    }))
  .pipe(concat(compiled_eco_js))
  .pipe(gulp.dest(build_path))
)