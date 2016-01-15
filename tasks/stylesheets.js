var gulp = require("gulp");
var sass = require('gulp-sass');

gulp.task("stylesheets", ['sass-compile'], function(){
  return gulp.src("./build/stylesheets/application.css")
    .pipe(gulp.dest("./public/stylesheets"));
});

gulp.task('sass-compile', function () {
  gulp.src('./client/styles/**/*.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./build/stylesheets'));
});