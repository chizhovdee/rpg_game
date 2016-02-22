path = require('path')
fs = require('fs')

class Config
  @default: (environment)->
    return @_default if @_default

    throw new Error('Arguments errors: environment is undefined') unless environment

    @_default = new @(@.loadConfigFromFile(environment))

  @loadConfigFromFile: (environment)->
    pathToFile = path.resolve('.', './config')

    configPath = path.join(pathToFile, 'odnoklassniki.json')

    cn = fs.readFileSync(configPath)

    JSON.parse(cn)[environment]

  constructor: (options = {})->
    for key, value of options
      Object.defineProperty(@, key,
        value: value
        enumerable: false
        configurable: false
        writable: false
      )

  canvasPageUrl: (protocol)->
    "#{ protocol }www.ok.ru/games/#{ @appId }"

module.exports = Config
