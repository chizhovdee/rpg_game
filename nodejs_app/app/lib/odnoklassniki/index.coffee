Config = require('./config')
Api = require('./api')

class Ok
  config: null
  api: null

  constructor: (environment)->
    @config = Config.default(environment)

    @api = new Api(@config)

  setSessionKeys: (sessionKey, sessionSecretKey)->
    @api.setSessionKeys(sessionKey, sessionSecretKey)

module.exports = Ok