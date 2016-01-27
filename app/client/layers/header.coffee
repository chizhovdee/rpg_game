Layer = require("../lib/layer")
Character = require("../models/character")
VisualTimer = require("../lib/visual_timer")
transport = require("../lib/transport")
sceneManager = require("../lib/scene_manager")

class HeaderLayer extends Layer
  elements:
    '.energy': 'energyEl'
    '.health': 'healthEl'

  epTimer: null
  hpTimer: null
  updateTimer: null
  updateIn: 0

  @changeState: (state)->
    # TO DO
    # метод класса предназначен для смены состояния хедера в зависимости от сцены

  hide: ->
    @epTimer?.stop()
    @epTimer = null

    @hpTimer?.stop()
    @hpTimer = null

    clearTimeout(@updateTimer)

    super

  show: ->
    @character = Character.first() # !!! должен быть ининциализован первым

    super

    @updateIn = 0

    @.render()

    @.setupTimers()
    @.startTimers()

  render: ->
    @html(@.renderTemplate("header"))

  bindEventListeners: ->
    super

    @character.bind("update", (args...)=> @.onCharacterUpdate(args...))

    @el.on("click", ".menu.quests", ->
      console.log "HUI"
      sceneManager.run('quests')
    )

  setupTimers: ->
    @epTimer = new VisualTimer(@energyEl.find(".timer"))
    @hpTimer = new VisualTimer(@healthEl.find(".timer"))

    @.setupUpdateTimer()

  setupUpdateTimer: (force = false)->
    calculatedUpdateIn = @.calculateUpdateIn()

    if force || @updateIn > calculatedUpdateIn || @updateIn == 0
      clearTimeout(@updateTimer)

      @updateTimer = setTimeout(
        => @.onUpdateTimerFinish()
        calculatedUpdateIn
      )

      @updateIn = calculatedUpdateIn

  startTimers: ->
    @.startEpTimer()
    @.startHpTimer()

  calculateUpdateIn: ->
    result = []

    result.push(_(1).minutes())
    result.push(@character.hp_restore_in) if @character.hp_restore_in > 0
    result.push(@character.ep_restore_in) if @character.ep_restore_in > 0

    _.min(result)

  updateEp: ->
    console.log "Updated ep"

    @energyEl.find(".value").text("#{ @character.restorable_ep } / #{ @character.energy_points }")
    @energyEl.find(".percentage").css(width: "#{ @character.epPercentage() }%")

    @.startEpTimer()

  startEpTimer: ->
    if @character.restorable_ep < @character.energy_points
      @epTimer.start(@character.ep_restore_in)

  updateHp: ->
    console.log "Updated hp"

    @healthEl.find(".value").text("#{ @character.restorable_hp } / #{ @character.health_points }")
    @healthEl.find(".percentage").css(width: "#{ @character.hpPercentage() }%")

    @.startHpTimer()

  startHpTimer: ->
    if @character.restorable_hp < @character.health_points
      @hpTimer.start(@character.hp_restore_in)

  onUpdateTimerFinish: ->
    transport.send("load_character_status")

  onCharacterUpdate: (character)->
    console.log "Character Update"
    # обновляем каждый фрагмент отдельно если нужно

    changes = character.changes()

    @.updateHp() if changes.restorable_hp?
    @.updateEp() if changes.restorable_ep?

    @.setupUpdateTimer(true)

module.exports = HeaderLayer