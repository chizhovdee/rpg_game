Modal = require("../modal")
Character = require('../../models').Character

class NewLevelModal extends Modal
  className: 'new_level modal'

  show: ->
    super

    @character = Character.first()

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('new_level')
    )

  bindEventListeners: ->
    super

  unbindEventListeners: ->
    super


module.exports = NewLevelModal