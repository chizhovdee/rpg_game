var gulp = require("gulp");

var browserify = require('browserify');
var source = require('vinyl-source-stream');
var fs = require("fs");
var concat = require('gulp-concat');
var buffer     = require('vinyl-buffer');
var file = require('gulp-file');

gulp.task("build", ["build:client", "build:server", "locales"]);
gulp.task("build:client", ["prepare:client"]);
gulp.task("build:server", ['coffee-compile:server', 'server-views-copy']);

gulp.task("server-views-copy", function(){
  return gulp.src('./server/views/**/*.ejs')
    .pipe(gulp.dest("./build/server/views/"));
});

gulp.task("prepare:client", [
  'coffee-compile:common',
  'coffee-compile:client',
  'eco-compile',
  'client-vendors',
  'game_data:populate',
  'stylesheets'
], function(){
  var vendors = fs.readFileSync("./build/client/vendors.js");

  return browserify("./build/client/main.js", {debug:false})
    .bundle()
    .pipe(source("application.js"))
    .pipe(gulp.dest("./public/javascripts/"))
    .pipe(file("vendor.js", vendors))
    .pipe(buffer())
    .pipe(concat("application.js"))
    .pipe(gulp.dest("./public/javascripts/"));
});