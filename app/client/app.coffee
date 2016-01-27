require("./lib/lodash_mixin").register()
require("./populate_game_data") # замещается автоматически при сборке

transport = require("./lib/transport")
Character = require("./models/character")
pageManager = require("./lib/page_manager")
pageManager.setup(require("./controllers/pages/export"))
preloader = require("./lib/preloader")
HeaderLayer = require("./controllers/layers/header")

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
    transport.one("character_game_data_loaded", (response)=> @.onCharacterGameDataLoaded(response))
    transport.bind("character_status_loaded", (response)=> @.onCharacterStatusLoaded(response))

    # события DOM

  onManifestLoadProgress: (e)->
    console.log "Total:", e.total, ", loaded:", e.loaded

  onManifestLoadComplete: ->
    console.log "onManifestLoadComplete"

    @.setTranslations()

    transport.send("loadCharacterGameData")

  onCharacterGameDataLoaded: (response)->
    console.log "onCharacterGameDataLoaded", response.character

    Character.create(response.character)

    HeaderLayer.show(el: $("#application .header"))

    pageManager.run("home")

  onCharacterStatusLoaded: (response)->
    console.log "onCharacterStatusLoaded"

    @character ?= Character.first()

    @character.updateAttributes(response.character)

  setTranslations: ->
    I18n.defaultLocale = window.lng
    I18n.locale = window.lng
    I18n.translations ?= {}
    I18n.translations[window.lng] = preloader.getResult("locale")

module.exports = App
