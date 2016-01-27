gulp = require("gulp")
concat = require('gulp-concat')

gulp.task('client-vendors', ->
  gulp.src("./app/client/vendor/**/*.js")
  .pipe(concat("vendors.js"))
  .pipe(gulp.dest("./build/client/"))
)
