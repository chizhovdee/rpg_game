_ = require("underscore")

class Base
  id: null
  key: null

  @configure: ->
    @records = {}
    @keysStore = {}

  @define: (key, callback)->
    obj = {}

    obj.id = @idByKey(key)
    obj.key = key

    callback?(obj)

    @create(obj)

  @create: (attributes)->
    obj = new @(attributes)

    @records[obj.id] = obj
    @keysStore[obj.key] = obj.id

    obj

  @idByKey: (key)->
    key

  @all: ->
    _.values(@records)

  @find: (keyOrId)->
    record = (
      if _.isNumber(keyOrId)
        @records[keyOrId]
      else
        @records[@keysStore[keyOrId]]
    )

    throw new Error("Game data object not found by id or key - #{ keyOrId }") unless record?

    record

  constructor: (attributes)->
    _.extend(@, attributes)


module.exports = Base