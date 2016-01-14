var gulp = require("gulp");
var concat = require('gulp-concat');

gulp.task("css-copy", function(){
  return gulp.src("./client/styles/application.css")
    .pipe(gulp.dest("./server/public/stylesheets"));
});
