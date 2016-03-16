_ = require("lodash")
crc = require('crc')
Requirement = require("../lib/requirement")
Reward = require("../lib/reward")

class Base
  id: null
  key: null
  requirement: null
  reward: null
  count: 0

  @configure: ->
    @records = []
    @idsStore = {}
    @keysStore = {}
    @count = 0

    @beforeDefineCallbacks = []
    @afterDefineCallbacks = []

  @beforeDefine: (callbacks...)->
    @beforeDefineCallbacks = callbacks

  @afterDefine: (callbacks...)->
    @afterDefineCallbacks = callbacks

  @define: (key, callback)->
    obj = new @()

    obj[cb]?() for cb in @beforeDefineCallbacks

    obj.id = @idByKey(key)
    obj.key = key

    callback?(obj)

    index = @records.push(obj)
    @idsStore[obj.id] = index - 1
    @keysStore[obj.key] = index - 1
    @count += 1

    obj[cb]?() for cb in @afterDefineCallbacks

    obj # возвращаем объект!

  @idByKey: (key)->
    crc.crc32(key)

  @toJSON: ->
    all = _.map(@all(), (obj)-> obj.toJSON())

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

  @first: ->
    @records[0]

  @findAllByAttribute: (attribute, value)->
    _.filter(@all(), (record)-> record[attribute] == value)

  @findByAttributes: (attributes = {})->
    _.find(@all(), attributes)

  constructor: (attributes = {})->
    @id = null
    @key = null
    @requirement = null
    @reward = null

    _.assignIn(@, attributes)

  addRequirement: (trigger, callback)->
    @requirement ?= new Requirement()

    callback?(@requirement.on(trigger))

  addReward: (trigger, callback)->
    @reward ?= new Reward()

    callback?(@reward.on(trigger))

  toJSON: ->
    {
      id: @id
      key: @key
    }


module.exports = Base