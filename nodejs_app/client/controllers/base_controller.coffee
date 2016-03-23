utils = require("../utils")

class BaseController extends Spine.Controller
  @include utils.render
  @include utils.time
  @include utils.design
  @include utils.assets
  @include utils.pictures

  @show: ->

  @hide: ->

  show: ->
    @.unbindEventListeners()
    @.bindEventListeners()

  hide: ->
    @.unbindEventListeners()

    @el.remove()

  bindEventListeners: ->

  unbindEventListeners: ->

  renderPreloader: ->
    @html "<div class='loading'></div>"

module.exports = BaseController