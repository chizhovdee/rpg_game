_ = require("underscore")
JST = require("../build/JST").JST

RenderUtils =
  renderTemplate: (name, args...)->
    JST[name](_.extend({}, @, args...))

module.exports = RenderUtils