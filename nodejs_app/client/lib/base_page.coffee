BaseController = require("./base_controller")

class BasePage extends BaseController
  @show: ->
    super

    @page ?= new @()
    @page.show()

  @hide: ->
    super

    @page?.hide()
    @page = null

  show: ->
    super

    $("#application .page_wrapper").append(@el)

  hide: ->
    super

module.exports = BasePage
