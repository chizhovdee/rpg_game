_ = require("lodash")

class Base
  id: null
  key: null

  @configure: ->
    @records = []
    @idsStore = {}
    @keysStore = {}

  @define: (key, callback)->
    obj = {}

    obj.id = @idByKey(key)
    obj.key = key

    callback?(obj)

    @create(obj)

  @create: (attributes)->
    obj = new @(attributes)

    index = @records.push(obj)
    @idsStore[obj.id] = index - 1
    @keysStore[obj.key] = index - 1

    obj

  # server
  @idByKey: (key)->
    _.gameDataIdByKey(key)

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
    @records

  @find: (keyOrId)->
    record = (
      if _.isNumber(keyOrId)
        @records[@idsStore[keyOrId]]
      else
        @records[@keysStore[keyOrId]]
    )

    throw new Error("Game data object not found by id or key - #{ keyOrId }") unless record?

    record

  @findAllByAttribute: (attribute, value)->
    _.filter(@all(), (record)-> record[attribute] == value)

  constructor: (attributes)->
    _.assignIn(@, attributes)

  forClient: ->
    {
      id: @id
      key: @key
    }


module.exports = Base