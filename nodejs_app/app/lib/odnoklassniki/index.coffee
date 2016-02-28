Config = require('./config')
Api = require('./api')
middleware = require('./middleware')

# класс Ok позволяет напрямую делать апи вызовы одноклассников в любом месте
# может использоваться независимо
# ok = new Ok('development')
# ok.api.call('method', params, callback)
class Ok
  config: null
  api: null

  constructor: (environment)->
    @config = Config.default(environment)

    @api = new Api(@config)

  setSessionKeys: (sessionKey, sessionSecretKey)->
    @api.setSessionKeys(sessionKey, sessionSecretKey)

# использование middleware через app.use позволяет установить текущего пользователя в одноклассниках,
# а также дополнительные методы и параметры.
# делать апи вызовы можно через request.currentOkUser.apiClient().call('method', params, callback)
Ok.middleware = middleware

module.exports = Ok