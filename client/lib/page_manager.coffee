module.exports =
  setup: (@pages)->

  clear: ->
    for name, page of @pages
      page.hide()

  run: (page)->
    @clear()

    if @pages[page]?
      @pages[page].show()
    else
      console.error("Unknown page:", page)

