_ = require('lodash')
Encryptor = require('simple-encryptor')
md5 = require('md5')
Api = require('./api')

class User
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

  isAuthenticated: ->

  sessionKey: ->
    @options['session_key']

  uid: ->
    @options['logged_user_id']

  sessionSecretKey: ->
    @options['session_secret_key']

  apiconnection: ->
    @options['apiconnection']

  # referrer data
  refplace: ->
    @options['refplace']

  referer: ->
    @options['referer']

  apiClient: ->
    @_apiClient ?= new Api(@config, @.sessionKey(), @.sessionSecretKey())

module.exports = User