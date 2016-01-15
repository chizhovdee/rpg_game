var gulp = require('gulp');
var browserify = require('browserify');
var source = require('vinyl-source-stream');
var fs = require("fs");
var concat = require('gulp-concat');
var buffer     = require('vinyl-buffer');
var file = require('gulp-file');

var sourceFile = "./build/client/scripts/main.js";
var destFolder = "./public/javascripts/";
var destFile = "application.js";

gulp.task('browserify', function() {
  return browserify(sourceFile, { debug: false })
    .bundle()
    .pipe(source(destFile))
    .pipe(gulp.dest(destFolder));
});

gulp.task('browserify-concat', function() {
  var vendors = fs.readFileSync("./build/client/scripts/vendors.js");

  return browserify(sourceFile, {debug:true})
    .bundle()
    .pipe(source(destFile))
    .pipe(gulp.dest(destFolder))
    .pipe(file("vendor.js", vendors))
    .pipe(buffer())
    .pipe(concat(destFile))
    .pipe(gulp.dest(destFolder));
});

