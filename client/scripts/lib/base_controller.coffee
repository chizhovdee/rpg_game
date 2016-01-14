RenderUtils = require("../utils/render")
TimeUtils = require("../utils/time")
DesignUtils = require("../utils/design")

class BaseController extends Spine.Controller
  @include RenderUtils
  @include TimeUtils
  @include DesignUtils

  @show: ->

  @hide: ->

  show: ->
    @.bindEventListeners()

  hide: ->
    @.unbindEventListeners()

    @el.remove()

  bindEventListeners: ->

  unbindEventListeners: ->

module.exports = BaseController