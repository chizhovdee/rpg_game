BaseController = require('./base_controller')

class Modal extends BaseController
  @show: (data)->
    super

    @modal ?= new @()
    @modal.show(data)

  @hide: ->
    @modal?.hide()

    @modal = null

    super

  constructor: ->
    super

    @modalsEl ?= $("#modals")

  bindEventListeners: ->
    super

    @modalsEl.on('click', @.onModalsElementClick)

    @el.on('click', '.close:not(.disabled)', @.onCloseClick)

  unbindEventListeners: ->
    super

    @modalsEl.off('click', @.onModalsElementClick)

    @el.off('click', '.close:not(.disabled)', @.onCloseClick)

  show: ->
    super

    @modalsEl.show()

    @modalsEl.append(@el)

  hide: ->
    super

    if $('.modal').length == 0
      @modalsEl.hide()

  close: ->
    @.hide()

  updateContent: (content)->
    @.html(@.renderTemplate('modal', content: content))

  onModalsElementClick: (e)=>
    @.close() if e.target.id == 'modals'

  onCloseClick: (e)=>
    $(e.currentTarget).addClass('disabled')

    @.close()

module.exports = Modal