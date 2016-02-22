gulp = require("gulp")
browserify = require('browserify')
source = require('vinyl-source-stream')
fs = require("fs")
concat = require('gulp-concat')
buffer     = require('vinyl-buffer')
file = require('gulp-file')

gulp.task('watch', ->
  gulp.watch('./app/**/*.coffee', ["build:server"])

  gulp.watch('./app/views/**/*.ejs', ["server-views-copy"])

  gulp.watch('./app/db/game_data/**/*.coffee', ["game-data-populate-browserify"])

  gulp.watch('./client/**/*.coffee', ["client-compile-browserify"])

  gulp.watch('./client/views/**/*.eco', ["eco-compile-browserify"])

  gulp.watch('./client/styles/**/*.scss', ["stylesheets"])

  gulp.watch('./config/locales/**/*.yml', ["locales"])
)

browserifyConcat = ->
  vendors = fs.readFileSync("./build/client/vendors.js");

  browserify("./build/client/main.js", debug: false)
  .bundle()
  .pipe(source("application.js"))
  .pipe(gulp.dest("./public/javascripts/"))
  .pipe(file("vendor.js", vendors))
  .pipe(buffer())
  .pipe(concat("application.js"))
  .pipe(gulp.dest("./public/javascripts/"))


gulp.task("game-data-populate-browserify", ['game_data:populate'], ->
  browserifyConcat()
)

gulp.task("client-compile-browserify", ['coffee-compile:client'], ->
  browserifyConcat()
)

gulp.task("eco-compile-browserify", ['eco-compile'], ->
  browserifyConcat()
)
