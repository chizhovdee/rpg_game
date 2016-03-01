gulp = require('gulp')

gulp.task('images', ->
  gulp.src('./client/images/**')
  .pipe(gulp.dest('./public/assets'))
)