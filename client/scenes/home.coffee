Scene = require("../lib/scene.js")
Character = require("../models/character.js")
sceneManager = require("../lib/scene_manager.js")

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
