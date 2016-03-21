_ = require("lodash")
Base = require("./base")

class ItemGroup extends Base
  @configure()

  constructor: ->
    Object.defineProperties(@,
      _items: {
        value: []
        writable: false
      }
      items: {
        enumerable: true
        get: -> @_items
      }
    )

  addItem: (item)->
    _.addUniq(@_items, item)

module.exports = ItemGroup