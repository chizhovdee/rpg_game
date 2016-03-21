Base = require("./base")

class Item extends Base
  @configure 'Item', 'key', 'item_group_key', 'level', 'tags', 'effects', 'reward',
    'basic_price', 'vip_price'

  name: ->
    I18n.t("game_data.items.#{@key}")

module.exports = Item