require("./lib/lodash_mixin").register()
require("./populate_game_data") # замещается автоматически при сборке

request = require("./lib/request")
Character = require("./models").Character
preloader = require("./lib/preloader")
signatureKeeper = require('./lib/signature_keeper')
HeaderLayout = require("./controllers/layouts").HeaderLayout
HomePage = require('./controllers/pages').HomePage

# сначала грузиться манифест с помощью прелоадера
# затем загружается персонаж
# затем запускается главная сцена

class App
  character: null

  constructor: ->
    @.setupEventListeners()

    preloader.loadManifest([
      {id: "locale", src: "locales/#{ window.lng }.json"}
    ])

  # все общие события для игры
  setupEventListeners: ->
    # события прелоадера
    preloader.on("complete", @.onManifestLoadComplete, this)
    preloader.on("progress", @.onManifestLoadProgress, this)

    # события транспорта
    request.one("character_game_data_loaded", (response)=> @.onCharacterGameDataLoaded(response))
    request.bind("character_status_loaded", (response)=> @.onCharacterStatusLoaded(response))
    request.bind('not_authenticated', @.onCharacterNotAuthorized)
    request.bind('server_error', @.onServerError)
    request.bind('not_reached_level', @.onNotReachedLevel)

    $.ajaxSetup(beforeSend: @.onAjaxBeforeSend)

    # события DOM

  onManifestLoadProgress: (e)->
    console.log "Total:", e.total, ", loaded:", e.loaded

  onManifestLoadComplete: ->
    console.log "onManifestLoadComplete"

    @.setTranslations()

    request.send("loadCharacterGameData")

  onCharacterGameDataLoaded: (response)->
    console.log "onCharacterGameDataLoaded", response.character

    Character.create(response.character)

    HeaderLayout.show(el: $("#application .header"))

    #pageManager.run("home")

    HomePage.show()

  onCharacterStatusLoaded: (response)->
    console.log "onCharacterStatusLoaded"

    @character ?= Character.first()

    @character.updateAttributes(response.character)

  setTranslations: ->
    I18n.defaultLocale = window.lng
    I18n.locale = window.lng
    I18n.translations ?= {}
    I18n.translations[window.lng] = preloader.getResult("locale")

  onCharacterNotAuthorized: ->
    alert('Персонаж не авторизован')

  onAjaxBeforeSend: (request)->
    signature = signatureKeeper.getSignature()
    signatureName = signatureKeeper.getSignatureName()

    request.setRequestHeader(signatureName.split('_').join('-'), signature)

  onServerError: (response)->
    console.error 'Server Error:', response.error

    $('#application .notification').notify(I18n.t('common.server_error')
        {
          elementPosition: 'top center'
          arrowShow: false
          className: 'error'
          showDuration: 200
        }
    )

  onNotReachedLevel: ->
    $('#application .notification').notify(I18n.t('common.not_reached_level')
      {
        elementPosition: 'top center'
        arrowShow: false
        className: 'error'
        showDuration: 200
      }
    )

module.exports = App
