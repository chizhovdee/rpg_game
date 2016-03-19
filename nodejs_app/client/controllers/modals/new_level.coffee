Modal = require("../modal")
Character = require('../../models').Character
CharacterUpgradeModal = require('./character_upgrade')

class NewLevelModal extends Modal
  className: 'new_level modal'

  show: (@character)->
    super

    changes = @character.changes()

    @newPoints = changes.points[1] - changes.points[0]

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('new_level')
    )

  bindEventListeners: ->
    super

    @el.on('click', 'button.upgrade', @.onUpgradeButtonClick)

  unbindEventListeners: ->
    super

    @el.off('click', 'button.upgrade', @.onUpgradeButtonClick)

  onUpgradeButtonClick: =>
    @.close()

    CharacterUpgradeModal.show()


module.exports = NewLevelModal