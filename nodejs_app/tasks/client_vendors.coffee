gulp = require("gulp")
concat = require('gulp-concat')

gulp.task('client-vendors', ->
  gulp.src("./client/vendor/**/*.js")
  .pipe(concat("vendors.js"))
  .pipe(gulp.dest("./build/client/"))
)
