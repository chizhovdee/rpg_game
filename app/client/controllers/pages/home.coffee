Page = require("../../lib/base_page")
Character = require("../../models/character")

class HomePage extends Page
  className: "home page_block"

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
