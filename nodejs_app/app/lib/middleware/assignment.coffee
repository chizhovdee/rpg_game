module.exports = ({db: db, redis: redis})->
  (req, res, next)->
    req.db = db
    req.redis = redis

    next()