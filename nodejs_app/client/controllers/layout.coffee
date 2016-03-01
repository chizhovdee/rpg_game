BaseController = require("./base_controller")

class Layout extends BaseController
  @show: (data = {})->
    super

    throw new Error("Requires 'el' data options for layer rendering") unless data.el?

    @layer ?= new @(data)
    @layer.show()

  @hide: ->
    @layer?.hide()
    @layer = null

    super

  show: ->
    super

  hide: ->
    super

module.exports = Layout