require('coffee-script/register');

var gulp = require("gulp");
var gameData = require("../server/game_data");
var fs = require("fs");
var ejs = require("ejs");

gulp.task("game_data:populate", function(){
  fs.readdirSync("./server/db/game_data/").forEach(function(name) {
    if(name.indexOf(".coffee") > 0){
      obj = require("../server/db/game_data/" + name);
    }

    obj.define()
  });

  console.log(gameData);

  var tmpl = fs.readFileSync("./tasks/game_data_populate.ejs");

  result = ejs.render(tmpl.toString(), {data: gameData});

  fs.writeFileSync("./build/client/scripts/populate_game_data.js", result)
});

gulp.task("game_data:copy", function(){
  var baseName;
  var resultClient = "";
  var resultServer = "";
  var baseString = "";

  fs.readdirSync("./common/game_data/").forEach(function(name){
    if(name.indexOf(".coffee") > 0 && name != "base.coffee"){
      baseName = name.split(".coffee")[0];

      console.log(capitalize(baseName));

      baseString = "exports." + capitalize(baseName);

      resultClient += baseString + " = require('../../common/game_data/" + baseName + "')\n";
      resultServer += baseString + " = require('../common/game_data/" + baseName + "')\n";
    }
  });

  fs.writeFileSync("./client/scripts/game_data.coffee", resultClient);
  fs.writeFileSync("./server/game_data.coffee", resultServer);
});

function capitalize(string){
  var result = "";
  var strings = string.split("_");

  strings.forEach(function(str){
    result += str.charAt(0).toUpperCase() + str.substring(1).toLowerCase();
  });

  return result;
}