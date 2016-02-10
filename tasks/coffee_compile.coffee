gulp = require("gulp")
coffee = require('gulp-coffee')
gutil = require("gulp-util")
notify = require('gulp-notify')

build_path = "./build/"

tasks = ['coffee-compile:server', 'coffee-compile:client']

gulp.task('coffee-compile', tasks)

gulp.task('coffee-compile:server', ->
  gulp.src('./app/server/**/*.coffee')
  .pipe(coffee({bare: true}).on('error', gutil.log))
  .on('error', notify.onError({
      title: "COFFEE server dir ERROR",
      message: "Look in the console for details.\n <%= error.message %>"
    }))
  .pipe(gulp.dest(build_path + 'server/'))
)

gulp.task('coffee-compile:client', ->
  return gulp.src('./app/client/**/*.coffee')
  .pipe(coffee({bare: true}).on('error', gutil.log))
  .on('error', notify.onError({
      title: "COFFEE client dir ERROR",
      message: "Look in the console for details.\n <%= error.message %>"
    }))
  .pipe(gulp.dest(build_path + "client/"))
)