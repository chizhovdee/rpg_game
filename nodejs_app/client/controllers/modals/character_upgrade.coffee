Modal = require("../modal")
Character = require('../../models').Character

class CharacterUpgradeModal extends Modal
  className: 'character_upgrade modal'

  show: ->
    super

    @character = Character.first()

    @attributes = {
      energy: @character.energy_points
      health: @character.health_points
    }

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('characters/character_upgrade')
    )

  bindEventListeners: ->
    super

  unbindEventListeners: ->
    super


module.exports = CharacterUpgradeModal