Layout = require("../layout")
Character = require("../../models").Character
VisualTimer = require("../../lib/visual_timer")
request = require("../../lib/request")
pages = require('../pages')

class HeaderLayout extends Layout
  elements:
    '.energy': 'energyEl'
    '.health': 'healthEl'
    '.basic_money': 'basicMoneyEl'
    '.vip_money': 'vipMoneyEl'
    '.experience': 'experienceEl'
    '.level': 'levelEl'

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

    @el.on("click", ".menu.quests", -> pages.QuestPage.show())

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
    request.send("load_character_status")

  onCharacterUpdate: (character)->
    console.log "Character Update"
    # обновляем каждый фрагмент отдельно если нужно

    changes = character.changes()

    @.updateHp() if changes.restorable_hp?
    @.updateEp() if changes.restorable_ep?

    @basicMoneyEl.find('.value').text(@character.basic_money) if changes.basic_money
    @vipMoneyEl.find('.value').text(@character.vip_money) if changes.vip_money
    @experienceEl.find('.value').text(@character.experience) if changes.experience
    @levelEl.find('.value').text(@character.level) if changes.level

    @.setupUpdateTimer(true)

module.exports = HeaderLayout