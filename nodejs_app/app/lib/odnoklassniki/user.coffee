_ = require('lodash')
Encryptor = require('simple-encryptor')
md5 = require('md5')
Api = require('./api')

class User
  SOCIAL_FIELDS = [
    'session_key'
    'logged_user_id'
    'session_secret_key'
    'apiconnection'
    'refplace'
    'referer'
  ]

  config: null
  options: null

  @fromOkParams: (config, params)->
    params = @.decrypt(config, params) if _.isString(params)

    return unless params && params['logged_user_id'] && @.isSignatureValid(config, params)

    new @(config, params)

  @decrypt: (config, encryptedParams)->
    encryptor = new Encryptor("secret_key_#{ config.secretKey }")

    result = encryptor.decrypt(encryptedParams)

    unless result
      console.error new Error("\nError while decoding odnoklassniki params: \"#{ encryptedParams }\"")

    result

  @isSignatureValid: (config, params)->
    params['sig'] == @.calculateSignature(config, params)

  @calculateSignature: (config, params)->
    params = _.omit(params, ['sig'])

    sortedObject = _.orderBy(({key: key} for key in _.keys(params)), ['key'], ['asc'])

    paramString = ''

    for obj in sortedObject
      paramString += "#{ obj.key }=#{ params[obj.key] }"

    md5(paramString + config.secretKey)

  constructor: (@config, @options = {})->
    for field in SOCIAL_FIELDS
      name = (if field == 'logged_user_id' then 'uid' else field)

      Object.defineProperty(@, name,
        value: @options[field]
        enumerable: false
        configurable: false
        writable: false
      )

  isAuthenticated: ->
    @options['session_key']? && @options['session_key'].length > 0

  apiClient: ->
    @_apiClient ?= new Api(@config, @sessionKey, @sessionSecretKey)

module.exports = User