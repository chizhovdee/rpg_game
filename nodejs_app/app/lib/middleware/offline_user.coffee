_ = require('lodash')

class User
  uid: null

  isAuthenticated: ->
    true

module.exports = (req, res, next)->
  signed_params = (
    if req.query.OFFLINE == 'true' && req.query.user
      _.clone(req.query)
    else if req.get('signed-params') || req.cookies['signed_params']
      _.clone(req.get('signed-params') || req.cookies['signed_params'])
    else
      null
  )

  if signed_params
    user = new User()
    user.uid =  _.toInteger(signed_params.user)

    req.currentOfflineUser = user

    req.offlineSignedParams = _.clone(signed_params)

  next()