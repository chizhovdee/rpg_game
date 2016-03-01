BaseController = require("./base_controller")

class Page extends BaseController
  @show: ->
    super

    # вызываем событие изменения страницы
    Spine.Events.trigger('page_changed')

    @page ?= new @()
    @page.show()

    # после инициализации страницы, мы назначаем событие
    # Внимание! Колбек должен вызываться в замыкании, чтобы не потерять @page
    Spine.Events.one('page_changed', => @.onPageChanged())

  @onPageChanged: ->
    console.log 'page changed', @page.constructor.name
    @.hide()

  @hide: ->
    super

    @page?.hide()
    @page = null

  show: ->
    super

    $("#application .page_wrapper").append(@el)

  hide: ->
    super

module.exports = Page
