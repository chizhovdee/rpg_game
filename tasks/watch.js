var gulp = require("gulp");
var browserify = require('browserify');
var source = require('vinyl-source-stream');
var fs = require("fs");
var concat = require('gulp-concat');
var buffer     = require('vinyl-buffer');
var file = require('gulp-file');

gulp.task('watch', function(){
  gulp.watch('./server/**/*.coffee', ["build:server"]);

  gulp.watch('./server/views/**/*.ejs', ["server-views-copy"]);

  gulp.watch('./common/**/*.coffee', ["common-compile-browserify"]);

  gulp.watch('./client/scripts/**/*.coffee', ["client-compile-browserify"]);

  gulp.watch('./client/scripts/views/**/*.eco', ["eco-compile-browserify"]);

  gulp.watch('./locales/**/*.yml', ["locales"]);
});


gulp.task("common-compile-browserify", ['coffee-compile:common'], function(){
  return browserifyConcat();
});

gulp.task("client-compile-browserify", ['coffee-compile:client'], function(){
  return browserifyConcat();
});

gulp.task("eco-compile-browserify", ['eco-compile'], function(){
  return browserifyConcat();
});

function browserifyConcat(){
  var vendors = fs.readFileSync("./build/client/scripts/vendors.js");

  return browserify("./build/client/scripts/main.js", {debug:true})
    .bundle()
    .pipe(source("application.js"))
    .pipe(gulp.dest("./public/javascripts/"))
    .pipe(file("vendor.js", vendors))
    .pipe(buffer())
    .pipe(concat("application.js"))
    .pipe(gulp.dest("./public/javascripts/"));
}