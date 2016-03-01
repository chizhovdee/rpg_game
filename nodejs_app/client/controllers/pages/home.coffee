Page = require("../page")
Character = require("../../models").Character

class HomePage extends Page
  className: "home page"

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

module.exports = HomePage
