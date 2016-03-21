Base = require("./base")

class ItemGroup extends Base
  @configure 'ItemGroup', 'key'

  name: ->
    I18n.t("game_data.item_groups.#{@key}")

module.exports = ItemGroup