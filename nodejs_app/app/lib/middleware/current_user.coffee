_ = require('lodash')
Character = require('../../models').Character

AUTHENTICATED_USERS_KEY = 'authenticated_users'
USER_FIELDS = ['id', 'social_id', 'last_visited_at']

VISIT_DURATION = _(1).minutes()

addToRedis = (redis, key, user)->
  redis.set(key, JSON.stringify(user))

  redis.expire(key, VISIT_DURATION / 1000)

middleware = (request, callback)->
  currentSocialUser = request.currentSocialUser

  socialId = _.toInteger(currentSocialUser.uid)

  authenticatedUserKey = "authenticated_user_#{ socialId }"

  currentUser = null

  redis = request.redis
  db = request.db

  # Шаги:
  # 1) Ищем пользователя в редисе
  # 2) Если не находим, то ищем в базе
  # 3) Если не находим, то создаем и добавляем в базу
  # 4) В случае успешного добавления в базу, добавляем в редис
  # 5) В случае успешного найденного пользователя в базе, добавляем в редис
  # 6) На любом этапе, в случае найденного пользователя, присваеваем к currentUser
  # и возвращаем null, как идентификатор того, что
  # ничего делать больше не надо и идем дальше по цепочке

  redis.get(authenticatedUserKey)
  .then((user)->

    if user
      currentUser = JSON.parse(user)
      currentUser.last_visited_at = Date.now() # присваеваем актуальное время

      null
    else # если небыл найден в редисе, то ищем в базе
      Character.fetchBySocialId(db, socialId)
  )
  .then((character)->
    if currentUser
      null

    else if character # если был найден в базе, то сохраняем в редисе
      currentUser = _.pick(character, USER_FIELDS)
      currentUser.last_visited_at = Date.now() # присваеваем актуальное время

      addToRedis(redis, authenticatedUserKey, currentUser)

      null

    else # если не был найден в базе, то создаем персонажа и сохраняем в базу
      character = Character.createDefault()

      character.social_id = socialId
      character.installed = currentSocialUser?.isAuthenticated()
      character.session_key = currentSocialUser.session_key
      character.session_secret_key = currentSocialUser.session_secret_key

      db.tx((t)->
        character.insertToDb(t)
      )
  )
  .then((character)->
    if currentUser
      null

    else # если игрок был сохранен в базу, то сохраняем его в редисе
      currentUser = _.pick(character, USER_FIELDS)

      currentUser.last_visited_at = Date.now() # присваеваем актуальное время

      addToRedis(redis, authenticatedUserKey, currentUser)

      null
  )
  .then(-> # последний шаг в цепочке, вызываем колбек и возвращаем текущего пользователя
    error = (
      if currentUser
        null
      else
        new Error("User authenticated error: can't create OR found character")
    )

    callback(error, currentUser)
  )
  .catch((error)->
    callback(error, null)
  )



module.exports = (req, res, next)->
  # TODO определение платформы здесь

  req.currentSocialUser = req.currentOkUser

  if req.currentSocialUser?.isAuthenticated()
    middleware(req, (error, currentUser)->
      if error
        res.sendEventError(error)
      else
        console.log 'currentUser', req.currentUser = currentUser

        next()
    )

  else
    res.sendEvent('not_authenticated')