BaseController = require('./base_controller')

class Modal extends BaseController
  @show: (data = {})->
    super

    @popup ?= new @()
    @popup.show(data)

  @hide: ->
    @popup?.hide()

    @popup = null

    super

  constructor: ->
    super

    @popupsEl ?= $("#popups")

  bindEventListeners: ->
    super

    @popupsEl.on('click', @.onPopupsElementClick)

    @el.on('click', '.close:not(.disabled)', @.onCloseClick)

  unbindEventListeners: ->
    super

    @popupsEl.off('click', @.onPopupsElementClick)

    @el.off('click', '.close:not(.disabled)', @.onCloseClick)

  show: (data)->
    super

    @popupsEl.show()

    @popupsEl.append(@el)

  hide: ->
    super

    if $('.popup').length == 0
      @popupsEl.hide()

  close: ->
    @.hide()

  updateContent: (content)->
    @.html(@.renderTemplate('popup', content: content))

  onPopupsElementClick: (e)=>
    @.close() if e.target.id == 'popups'

  onCloseClick: (e)=>
    $(e.currentTarget).addClass('disabled')

    @.close()

module.exports = Modal