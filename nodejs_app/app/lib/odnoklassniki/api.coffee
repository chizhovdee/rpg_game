request = require('request')
_ = require('lodash')
md5 = require('md5')

REST_API_URL = "http://api.odnoklassniki.ru/fb.do"

class Api
  config: null
  sessionKey: null
  sessionSecretKey: null

  constructor: (@config, @sessionKey, @sessionSecretKey)->
    throw new Error('Argument error: config is undefined') unless @config

    if @sessionKey && !@sessionSecretKey || !@sessionKey && @sessionSecretKey
      throw new Error('Argument error: sessionKey or sessionSecretKey is undefined')

  setSessionKeys: (@sessionKey, @sessionSecretKey)->
    unless @sessionKey && @sessionSecretKey
      throw new Error('Argument error: sessionKey or sessionSecretKey is undefined')

  call: (method, specificParams = {}, callback)->
    options = {
      url: REST_API_URL
      qs: @.signedCallParams(method, specificParams)
      json: true
    }

    request.get(options, (error, response, body)->

      if !error? && response.statusCode >= 500
        error = new Error("""
          Odnoklassniki API Error: status code - #{ response.statusCode }, message - #{ body }
        """)

      callback(error, body)
    )

  signedCallParams: (method, specificParams = {})->
    params = _.assignIn({
      method: method
      application_key: @config.publicKey
      format: 'json'
    }, specificParams)

    params['session_key'] = @sessionKey if @sessionKey?

    params['sig'] = @.calculateSignature(params)

    params

  calculateSignature: (params)->
    params = _.omit(params, ['sig', 'resig'])

    sortedObject = _.orderBy(({key: key} for key in _.keys(params)), ['key'], ['asc'])

    paramString = ''

    for obj in sortedObject
      paramString += "#{ obj.key }=#{ params[obj.key] }"

    secretKey = if params['session_key']? then @sessionSecretKey else @config.secretKey

    md5(paramString + secretKey)

module.exports = Api
