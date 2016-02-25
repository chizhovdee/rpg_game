#AUTHORIZED_USERS_KEY = 'authorized_users'
#
#addUserToRedis = (redis, user)->
#  redis.hset(AUTHORIZED_USERS_KEY, user.id, JSON.stringify(user))
#  redis.expire(AUTHORIZED_USERS_KEY, 1000) # 1000 seconds

class Middleware


module.exports = (req, res, next)->
  console.log '----------------------'
  console.log req.currentOkUser

  next()