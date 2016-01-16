BaseController = require("./base_controller")

class Scene extends BaseController
  @show: ->
    super

    @scene ?= new @()
    @scene.show()

  @hide: ->
    super

    @scene?.hide()
    @scene = null

  show: ->
    super

    $("#application .scene_wrapper").append(@el)

  hide: ->
    super

module.exports = Scene
