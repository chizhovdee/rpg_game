gulp = require("gulp")

browserify = require('browserify')
source = require('vinyl-source-stream')
fs = require("fs")
concat = require('gulp-concat')
buffer = require('vinyl-buffer')
file = require('gulp-file')

gulp.task("build", ["build:client", "build:server", "locales"])
gulp.task("build:client", ["prepare:client"])
gulp.task("build:server", ['coffee-compile:server', 'server-views-copy'])

gulp.task("server-views-copy", ->
  gulp.src('./app/views/**/*.ejs')
  .pipe(gulp.dest("./build/views/"))
)

gulp.task("prepare:client", [
  'coffee-compile:client',
  'eco-compile',
  'client-vendors',
  'game_data:populate',
  'stylesheets',
  'images'
], ->
  vendors = fs.readFileSync("./build/client/vendors.js")

  browserify("./build/client/main.js", {debug:false})
  .bundle()
  .pipe(source("application.js"))
  .pipe(gulp.dest("./public/assets/"))
  .pipe(file("vendor.js", vendors))
  .pipe(buffer())
  .pipe(concat("application.js"))
  .pipe(gulp.dest("./public/assets/"))
)