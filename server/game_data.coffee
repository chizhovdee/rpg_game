fs = require("fs")

exports.Quest = require("../common/game_data/quest")
exports.QuestGroup = require("../common/game_data/quest_group")

exports.forClient = ->
  {
    quest: exports.Quest.all()
    quest_group: exports.QuestGroup.all()
  }

exports.define = ->
  fs.readdirSync("#{ __dirname }/game_data/").forEach((name)->
    if name.indexOf(".js") > 0
      obj = require("./game_data/#{name}")

      obj.define()
  )