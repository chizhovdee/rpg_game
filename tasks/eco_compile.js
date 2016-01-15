var gulp = require("gulp");
var eco = require('gulp-eco');
var concat = require('gulp-concat');
var browserify = require('browserify');
var file = require('gulp-file');

var eco_files_path = "./client/scripts/views/**/*.eco";
var compiled_eco_js = "JST.js";
var build_path = "./build/client/scripts/";

gulp.task("eco-compile", function(){
  return gulp.src(eco_files_path)
    .pipe(eco({nameExport: "module.exports", basePath: 'client/scripts/views'}))
    .pipe(concat(compiled_eco_js))
    .pipe(gulp.dest(build_path));
});