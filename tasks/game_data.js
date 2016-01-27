var gulp = require("gulp");
var fs = require("fs");
var ejs = require("ejs");

gulp.task("game_data:populate", function(){
  require('require-dir')('../db/game_data', {recurse: true} );

  var baseName;
  var gameData = {};

  fs.readdirSync("./app/server/game_data/").forEach(function(name){
    if(name.indexOf(".coffee") > 0 && name != "base.coffee"){
      baseName = name.split(".coffee")[0];

      gameData[baseName] = require("../app/server/game_data/" + baseName);
    }
  });

  var tmpl = fs.readFileSync("./tasks/game_data_populate.ejs");

  result = ejs.render(tmpl.toString(), {data: gameData});

  fs.mkdir('./build', function() {
    fs.mkdir('./build/client', function () {
      fs.writeFileSync("./build/client/populate_game_data.js", result);
    });
  });
});

//gulp.task("game_data:copy", function(){
//  var baseName;
//  var result = "# This file has been generate automaticaly with gulp game_data:copy\n";
//  var baseString = "";
//
//  fs.readdirSync("./common/game_data/").forEach(function(name){
//    if(name.indexOf(".coffee") > 0 && name != "base.coffee"){
//      baseName = name.split(".coffee")[0];
//
//      console.log(capitalize(baseName));
//
//      baseString = "exports." + capitalize(baseName);
//
//      result += baseString + " = require('../common/game_data/" + baseName + "')\n";
//    }
//  });
//
//  fs.writeFileSync("./client/game_data.coffee", result);
//  fs.writeFileSync("./server/game_data.coffee", result);
//});
//
//function capitalize(string){
//  var result = "";
//  var strings = string.split("_");
//
//  strings.forEach(function(str){
//    result += str.charAt(0).toUpperCase() + str.substring(1).toLowerCase();
//  });
//
//  return result;
//}