class Timer
  tickLength: 1000

  constructor: (@finishCallback, @tickCallback, @stopCallback)->

  start: (countdown)->
    @.stop()

    return if countdown <= 0

    @lastTick = new Date().valueOf()
    @finishAt = @lastTick + countdown

    @ticker = Visibility.every(50, ()=> @.checkTick())

    @.onTick()

  stop: ()->
    if @ticker?
      Visibility.stop(@ticker)

      @ticker = null

      @finishAt = new Date().valueOf()

    @.onStop()

  secondsToFinish: ()->
    Math.round(
      (@finishAt - new Date().valueOf()) / 1000
    )

  checkTick: ->
    return unless @ticker?

    newTime = new Date().valueOf()

    if newTime - @lastTick >= @tickLength
      @lastTick = newTime

      @.onTick()

      if @lastTick >= @finishAt
        @.stop()

        @.onFinish()

  onTick: ()->
    @tickCallback?(@)

  onFinish: ()->
    @finishCallback?(@)

  onStop: ->
    @stopCallback?(@)

module.exports = Timer

