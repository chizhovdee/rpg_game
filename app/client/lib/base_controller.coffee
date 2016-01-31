class BaseController extends Spine.Controller
  @include require("../utils/render")
  @include require("../utils/time")
  @include require("../utils/design")

  @show: ->

  @hide: ->

  show: ->
    @.bindEventListeners()

  hide: ->
    @.unbindEventListeners()

    @el.remove()

  bindEventListeners: ->

  unbindEventListeners: ->

  renderPreloader: ->
    @html "<div class='loading'></div>"

module.exports = BaseController