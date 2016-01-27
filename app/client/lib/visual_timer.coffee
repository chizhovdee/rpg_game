Timer = require("./timer")
TimeUtils = require("../utils/time")

VisualTimer = class extends Timer
  constructor: (@element, @finishCallback, @tickCallback)->

  onTick: ->
    @.render()

    super

  onStop: ->
    @element.empty()

    super

  render: ->
    if @element.length > 0
      @element.text(
        TimeUtils.formatTime(@.secondsToFinish())
      )
    else
      @.stop()


module.exports = VisualTimer