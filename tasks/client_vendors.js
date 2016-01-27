var gulp = require("gulp");
var concat = require('gulp-concat');

gulp.task('client-vendors', function() {
  return gulp.src("./app/client/vendor/**/*.js")
    .pipe(concat("vendors.js"))
    .pipe(gulp.dest("./build/client/"));
});
