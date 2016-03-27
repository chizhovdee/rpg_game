_ = require("lodash")
Base = require("./base")
Group = require('./item_group')
Requirement = require("../lib/requirement")
Reward = require("../lib/reward")

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

  priceByAmount: (amount = 1)->
    price = {}

    price.basic = @basicPrice * amount if @basicPrice?
    price.vip = @vipPrice * amount if @vipPrice?

    price

  # price это объект, полученнный с помощью метода priceByAmount
  priceRequirement: (price)->
    _.tap(new Requirement(), (r)->
      r.basicMoney(price.basic) if price.basic?
      r.vipMoney(price.vip) if price.vip?
    )

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

Reward.setItemClass(Item) # для того чтобы не загружать модуль

module.exports = Item
