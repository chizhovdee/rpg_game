_ = require("underscore")
crc = require('crc')

exports.setup = ->
  _.mixin(
    gameDataIdByKey: (key) -> return crc.crc32(key)
  )