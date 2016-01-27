var gulp = require("gulp");
var eco = require('gulp-eco');
var concat = require('gulp-concat');
var browserify = require('browserify');
var file = require('gulp-file');
var notify = require('gulp-notify');

var eco_files_path = "./app/client/views/**/*.eco";
var compiled_eco_js = "JST.js";
var build_path = "./build/client/";

gulp.task("eco-compile", function(){
  return gulp.src(eco_files_path)
    .pipe(eco({nameExport: "module.exports", basePath: 'client/views'}))
    .on('error', notify.onError({
      title: "ECO templates ERROR",
      message: "Look in the console for details.\n <%= error.message %>"
    }))
    .pipe(concat(compiled_eco_js))
    .pipe(gulp.dest(build_path));
});