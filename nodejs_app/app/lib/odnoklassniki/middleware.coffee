_ = require('lodash')
Encryptor = require('simple-encryptor')

Config = require('./config')
User = require('./user')

class Middleware
  OK_PARAM_NAMES = [
    'logged_user_id'
    'api_server'
    'application_key'
    'session_key'
    'session_secret_key'
    'authorized'
    'apiconnection'
    'refplace'
    'referer'
    'auth_sig'
    'sig'
    'custom_args'
    'ip_geo_location'
    'new_sig'
  ]

  DEBUG_PARAMS = ['first_start', 'clientLog', 'web_server']

  config: null
  allParams: null
  storedSignedParams: null

  constructor: (request)->
    @allParams = {}
    _.assignIn(@allParams, request.query) unless _.isEmpty(request.query)
    _.assignIn(@allParams, request.params) unless _.isEmpty(request.params)
    _.assignIn(@allParams, request.body) unless _.isEmpty(request.body)

    @config = Config.default(request.app.get('env'))

    @storedSignedParams = @.getStoredSignedParams(request)

  getStoredSignedParams: (request)->
    request.get('signed-params') || @allParams['signed_params'] || request.cookies['signed_params']

  currentOkUser: ->
    @_currentOkUser ?= @.fetchCurrentOkUser()

  fetchCurrentOkUser: ->
    okParams = @.okParams()

    params = (
      if okParams['session_key']? && okParams['session_key'] != ''
        okParams
      else
        @.okSignedParams()
    )

    User.fromOkParams(@config, params)

  okSignedParams: ->
    okParams = @.okParams()

    if okParams['session_key']? && okParams['session_key'] != ''
      @.encrypt(okParams)
    else
      @storedSignedParams

  okParams: ->
    _.pick(@allParams, OK_PARAM_NAMES.concat(DEBUG_PARAMS))

  paramsWithoutOkData: ->
    _.omit(@allParams, OK_PARAM_NAMES.concat(DEBUG_PARAMS))

  encrypt: (params)->
    encryptor = new Encryptor("secret_key_#{ @config.secretKey }")

    encryptor.encrypt(params)

  decrypt: (encryptedParams)->
    encryptor = new Encryptor("secret_key_#{ @config.secretKey }")

    result = encryptor.decrypt(encryptedParams)

    unless result
      console.error new Error("\nError while decoding odnoklassniki params: \"#{ encryptedParams }\"")

    result

module.exports = (req, res, next)->
  middleware = new Middleware(req)

  #req.okConfig = middleware.config разлочить если понадобится
  req.currentOkUser = middleware.currentOkUser()
  req.okSignedParams = middleware.okSignedParams()

  middleware = null

  next()

