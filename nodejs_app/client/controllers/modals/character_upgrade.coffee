Modal = require("../modal")
Character = require('../../models').Character
characterUpgradeRates = require('../../settings').characterUpgradeRates
request = require('../../lib').request

class CharacterUpgradeModal extends Modal
  className: 'character_upgrade modal'

  show: ->
    super

    @character = Character.first()

    @points = @character.points

    @attributes = {
      energy: @character.energy_points
      health: @character.health_points
      attack: @character.attack
      defense: @character.defense
    }

    @operations = {}

    @.render()

  render: ->
    @updateContent(
      @.renderTemplate('characters/character_upgrade')
    )

    @.checkSaveButton()

  bindEventListeners: ->
    super

    request.bind('character_upgraded', @.onCharacterUpgraded)

    @el.on('click', '.attribute .controls .minus:not(.disabled)', @.onAttributeControlClck)
    @el.on('click', '.attribute .controls .plus:not(.disabled)', @.onAttributeControlClck)
    @el.on('click', 'button.save:not(.disabled)', @.onSaveButtonClick)
    @el.on('click', '.reset:not(.disabled)', @.onResetButtonClick)

  unbindEventListeners: ->
    super

    request.unbind('character_upgraded', @.onCharacterUpgraded)

    @el.off('click', '.attribute .controls .minus:not(.disabled)', @.onAttributeControlClck)
    @el.off('click', '.attribute .controls .plus:not(.disabled)', @.onAttributeControlClck)
    @el.off('click', 'button.save:not(.disabled)', @.onSaveButtonClick)
    @el.off('click', '.reset:not(.disabled)', @.onResetButtonClick)

  checkSaveButton: ->
    if @.canSave()
      @el.find('button.save').removeClass('disabled')
    else
      @el.find('button.save').removeClass('disabled').addClass('disabled')

  canSave: ->
    not _.isEmpty(@operations)

  onAttributeControlClck: (e)=>
    button = $(e.currentTarget)

    operation = button.data('operation')
    attribute = button.data('attribute')

    value = @operations[attribute] || 0

    if operation == 'minus'
      return if value <= 0

      value -= 1
      @points += 1
    else
      return if @points <= 0

      value += 1
      @points -= 1

    if value <= 0
      delete @operations[attribute]
    else
      @operations[attribute] = value

    @.render()

  onSaveButtonClick: (e)=>
    $(e.currentTarget).addClass('disabled')

    return unless @.canSave()

    request.send('upgrade_character', operations: @operations)

  attributeValue: (attribute)->
    value = (@operations[attribute] || 0) * characterUpgradeRates[attribute]

    @attributes[attribute] + value

  canIncrement: ->
    @points > 0

  canDecrement: (attribute)->
    @operations[attribute]?

  onCharacterUpgraded: (response)=>
    console.log 'onCharacterUpgraded'

    @.close()

    if response?.is_error
      @.displayError(I18n.t("characters.errors.#{response.error_code}"))
    else
      @.displaySuccess(I18n.t('characters.upgrade.success'))

  onResetButtonClick: =>
    console.log "Заглушка"



module.exports = CharacterUpgradeModal