require('coffee-script/register');
require("./app/lib/lodash_mixin").register();

var requireDir = require('require-dir');
requireDir('./tasks', { recurse: true });

var gulp = require('gulp');

gulp.task('default', ['build', 'watch'], function(){

});

