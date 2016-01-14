var gulp = require("gulp");
var concat = require('gulp-concat');

gulp.task('client-vendor', function() {
  return gulp.src("./client/scripts/vendor/**/*.js")
    .pipe(concat("vendors.js"))
    .pipe(gulp.dest("./client/scripts/build"));
});
