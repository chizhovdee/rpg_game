_ = require("underscore")
JST = require("../JST").JST

RenderUtils =
  renderTemplate: (name, args...)->
    JST[name](_.extend({}, @, args...))

module.exports = RenderUtils