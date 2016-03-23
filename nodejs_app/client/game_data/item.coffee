Base = require("./base")

class Item extends Base
  @configure 'Item', 'key', 'item_group_key', 'level', 'tags', 'effects', 'reward',
    'basic_price', 'vip_price'

  name: ->
    I18n.t("game_data.items.#{@key}")

  priceRequirement: (character)->
    requirement = {}

    if @basic_price? && @basic_price > 0
      requirement.basic_money = [@basic_price, character.basic_money >= @basic_price]

    if @vip_price? && @vip_price > 0
      requirement.vip_money = [@vip_price, character.vip_money >= @vip_price]

    requirement

module.exports = Item