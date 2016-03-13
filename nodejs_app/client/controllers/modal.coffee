BaseController = require('./base_controller')

modalList = []

class Modal extends BaseController
  @show: (args...)->
    super

    modal = new @()

    modalList.push([modal, args])

    if modalList.length > 1
      if _.find(modalList, (m)-> m[0].showed)? # проверяем есть ли открытый диалог
        $('.modal .close').notify(
          {content: @newDialogMessage || I18n.t('common.new_dialog')}
          {
            elementPosition: 'top right'
            autoHide: false
            style: "game"
            className: 'info'
            showDuration: 200
          }
        )
      else
        if modalData = modalList[0]
          modalData[0].show(modalData[1]...)
    else
      modal.show(args...)

  @close: ->
    @hide()

  @hide: ->
    _.find(modalList, (m)=> m[0].dialogKey == @name && m[0].showed)?[0].hide()

    super

  constructor: ->
    super

    @dialogId = Date.now()
    @dialogKey = @constructor.name

    @modalsEl ?= $("#modals")

  bindEventListeners: ->
    super

    @el.on('click', '.close:not(.disabled)', @.onCloseClick)

  unbindEventListeners: ->
    super

    @el.off('click', '.close:not(.disabled)', @.onCloseClick)

  show: ->
    super

    @showed = true

    @modalsEl.show()

    @modalsEl.append(@el)

  hide: ->
    super

    @showed = false

    # удаление текущего диалога
    modalList = _.reject(modalList, (m)=> m[0].dialogId == @dialogId && m[0].dialogKey == @dialogKey)

    # проверяем следующий по списку диалог
    if modalData = modalList[0]
      modalData[0].show(modalData[1]...)

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