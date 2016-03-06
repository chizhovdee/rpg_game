_ = require('lodash')
Encryptor = require('simple-encryptor')

class User
  uid: null

  isAuthenticated: ->
    @uid?

module.exports = (req, res, next)->
  encryptor = new Encryptor("secret_key_offline_user")

  signed_params = (
    if req.query.OFFLINE == 'true' && req.query.user
      req.query
    else if req.get('signed-params') || req.cookies['signed_params']
      encryptor.decrypt(req.get('signed-params') || req.cookies['signed_params'])
    else
      null
  )

  if signed_params
    user = new User()
    user.uid = _.toInteger(signed_params.user)

    req.currentOfflineUser = user

    req.offlineSignedParams = encryptor.encrypt(signed_params)

  next()