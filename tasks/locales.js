var gulp = require("gulp");
var map     = require('map-stream');
var yaml    = require('js-yaml');
var gutil = require("gulp-util");
var _ = require("underscore");

gulp.task('locales', function(){
  var data = {
    ru: {},
    en: {}
  };

  gulp.src('./locales/**/*.yml')
    .pipe(map(function(file,cb){
      if (file.isNull()) return cb(null, file); // pass along
      if (file.isStream()) return cb(new Error("Streaming not supported"));

      var json;
      var lng = "";

      try {
        json = yaml.load(String(file.contents.toString('utf8')));

        if(json.ru != null){
          lng = "ru";
        } else if (json.en != null) {
          lng = "en";
        } else {
          return cb(new Error("Language not supported"));
        }

        _.extend(data[lng], json[lng]);

      } catch(e) {
        console.log(e);
        console.log(json);
      }

      file = new gutil.File({
        cwd: "",
        base: "",
        path: lng + ".json",
        contents: new Buffer(JSON.stringify(data[lng]))
      });

      cb(null, file);
    }))
    .pipe(gulp.dest('./public/locales'));
});
