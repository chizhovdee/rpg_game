Scene = require("../lib/scene")
Character = require("../models/character")
sceneManager = require("../lib/scene_manager")

class HomeScene extends Scene
  className: "home scene"

  hide: ->
    super

  show: ->
    super

    @.render()

  render: ->
    @html(@.renderTemplate("home/index"))

  bindEventListeners: ->
    super

  unbindEventListeners: ->
    super

module.exports = HomeScene
