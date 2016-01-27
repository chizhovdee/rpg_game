sceneManager =
  setup: (@scenes)->

  clear: ->
    for name, scene of @scenes
      scene.hide()

  run: (scene)->
    @clear()

    if @scenes[scene]?
      @scenes[scene].show()
    else
      console.error("Unknown scene:", scene)

module.exports = sceneManager

