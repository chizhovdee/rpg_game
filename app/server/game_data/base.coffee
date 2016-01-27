_ = require("lodash")
crc = require('crc')
Requirement = require("../lib/requirement")
Reward = require("../lib/reward")

class Base
  id: null
  key: null
  requirement: null
  reward: null

  @configure: ->
    @records = []
    @idsStore = {}
    @keysStore = {}

  @define: (key, callback)->
    obj = new @()

    obj.id = @idByKey(key)
    obj.key = key

    callback?(obj)

    index = @records.push(obj)
    @idsStore[obj.id] = index - 1
    @keysStore[obj.key] = index - 1

  @idByKey: (key)->
    crc.crc32(key)

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

  constructor: (attributes = {})->
    @id = null
    @key = null
    @requirement = null
    @reward = null

    _.assignIn(@, attributes)

  addRequirement: (callback)->
    @requirement ?= new Requirement()

    callback?(@requirement)

  addReward: (callback)->
    @reward ?= new Reward()

    callback?(@reward)

  forClient: ->
    {
      id: @id
      key: @key
    }


module.exports = Base