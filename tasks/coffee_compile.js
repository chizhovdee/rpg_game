var gulp = require("gulp");
var coffee = require('gulp-coffee');
var gutil = require("gulp-util");
var notify = require('gulp-notify');

var build_path = "./build/";

var tasks = ['coffee-compile:server', 'coffee-compile:client'];

gulp.task('coffee-compile', tasks, function() {

});

gulp.task('coffee-compile:server', function() {
  return gulp.src('./app/server/**/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .on('error', notify.onError({
      title: "COFFEE server dir ERROR",
      message: "Look in the console for details.\n <%= error.message %>"
    }))
    .pipe(gulp.dest(build_path + 'server/'));
});

gulp.task('coffee-compile:client', function() {
  return gulp.src('./app/client/**/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .on('error', notify.onError({
      title: "COFFEE client dir ERROR",
      message: "Look in the console for details.\n <%= error.message %>"
    }))
    .pipe(gulp.dest(build_path + "client/"));
});