var gulp = require("gulp");
//var gameData = require("../server/game_data");
var fs = require("fs");
var ejs = require("ejs");

gulp.task("game_data", function(){
  gameData.define();

  //console.log(gameData.Quest.all());
  //console.log(gameData.QuestGroup.all());

  tmpl = fs.readFileSync(__dirname + "/game_data.ejs");

  result = ejs.render(tmpl.toString(), {data: gameData.forClient()});

  fs.writeFileSync("./game_data_gener.js", result)
});