var gulp = require("gulp");
var coffee = require('gulp-coffee');
var gutil = require("gulp-util");
var notify = require('gulp-notify');

var build_path = "./build/";

var tasks = ['coffee-compile:common', 'coffee-compile:server', 'coffee-compile:client'];

gulp.task('coffee-compile', tasks, function() {

});

gulp.task('coffee-compile:common', function() {
  return gulp.src('./common/**/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .on('error', notify.onError({
      title: "COFFEE common dir ERROR",
      message: "Look in the console for details.\n <%= error.message %>"
    }))
    .pipe(gulp.dest(build_path + "common/"));
});

gulp.task('coffee-compile:server', function() {
  return gulp.src('./server/**/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .on('error', notify.onError({
      title: "COFFEE server dir ERROR",
      message: "Look in the console for details.\n <%= error.message %>"
    }))
    .pipe(gulp.dest(build_path + "server/"));
});

gulp.task('coffee-compile:client', function() {
  return gulp.src('./client/**/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .on('error', notify.onError({
      title: "COFFEE client dir ERROR",
      message: "Look in the console for details.\n <%= error.message %>"
    }))
    .pipe(gulp.dest(build_path + "client/"));
});