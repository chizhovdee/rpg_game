gulp = require('gulp')
browserify = require('browserify')
source = require('vinyl-source-stream')
fs = require("fs")
concat = require('gulp-concat')
buffer     = require('vinyl-buffer')
file = require('gulp-file')

sourceFile = "./build/client/main.js"
destFolder = "./public/javascripts/"
destFile = "application.js"

gulp.task('browserify', ->
  browserify(sourceFile, { debug: false })
  .bundle()
  .pipe(source(destFile))
  .pipe(gulp.dest(destFolder))
)

gulp.task('browserify-concat', ->
  vendors = fs.readFileSync("./build/client/vendors.js")

  browserify(sourceFile, {debug:true})
  .bundle()
  .pipe(source(destFile))
  .pipe(gulp.dest(destFolder))
  .pipe(file("vendor.js", vendors))
  .pipe(buffer())
  .pipe(concat(destFile))
  .pipe(gulp.dest(destFolder))
)

