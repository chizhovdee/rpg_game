_ = require("lodash")
JST = require("../JST").JST

RenderUtils =
  renderTemplate: (name, args...)->
    JST[name](_.assignIn({}, @, args...))

module.exports = RenderUtils