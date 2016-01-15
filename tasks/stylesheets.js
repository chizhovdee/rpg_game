var gulp = require("gulp");
var sass = require('gulp-sass');
var notify = require('gulp-notify');

gulp.task("stylesheets", ['sass-compile'], function(){
  return gulp.src("./build/stylesheets/application.css")
    .pipe(gulp.dest("./public/stylesheets"));
});

gulp.task('sass-compile', function () {
  gulp.src('./client/styles/**/*.scss')
    .pipe(sass()) //.on('error', sass.logError))
    .on('error', notify.onError({
      title: "SASS ERROR",
      message: "Look in the console for details.\n <%= error.message %>"
    }))
    .pipe(gulp.dest('./build/stylesheets'));
});