_ = require("lodash")
Base = require("./base")
Group = require('./item_group')

class Item extends Base
  itemGroupKey: null
  level: null
  effects: null
  basicPrice: null
  vipPrice: null

  @configure()

  @afterDefine 'setGroup'

  constructor: ->
    super

    @effects = {}
    @basicPrice = null
    @vipPrice = null

  setGroup: ->
    Object.defineProperty(@, 'group'
      value: Group.find(@itemGroupKey)
      writable: false
      enumerable: true
    )

    @group.addItem(@)

  validationForDefine: ->
    throw new Error('level is undefined') unless @level
    throw new Error('level must be greater than zero') if @level <= 0
    throw new Error('itemGroupKey is undefined') unless @itemGroupKey
    throw new Error('undefined price') if !@basicPrice? && !@vipPrice?

  toJSON: ->
    _.assign(
      item_group_key: @itemGroupKey
      level: @level
      reward: @reward
      tags: @tags
      basic_price: @basicPrice
      vip_price: @vipPrice
      effects: @effects
      ,
      super
    )

module.exports = Item
