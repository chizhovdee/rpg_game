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

  # server
  @idByKey: (key)->
    _(key).gameDataIdByKey() # underscore mixin

  @populate: (data)->
    for values in data.values
      obj = {}

      for value, index in values
        obj[data.keys[index]] = value

      @create(obj)

  @forClient: ->
    all = _.map(@all(), (obj)-> obj.forClient())

    keys = _.keys(all[0])

    values = []

    for obj in all
      data = []

      for key in keys
        data.push obj[key]

      values.push data

    {
      keys: keys,
      values: values
    }

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

  forClient: ->
    {
      id: @id
      key: @key
    }


module.exports = Base