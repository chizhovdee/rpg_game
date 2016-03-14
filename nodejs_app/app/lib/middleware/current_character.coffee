_ = require('lodash')
Character = require('../../models').Character

CHARACTER_FIELDS = ['id', 'social_id', 'last_visited_at']

VISIT_DURATION = _(30).minutes()

addToRedis = (redis, key, character)->
  redis.set(key, JSON.stringify(character))

  redis.expire(key, VISIT_DURATION / 1000)

middleware = (request, callback)->
  currentSocialUser = request.currentSocialUser

  socialId = currentSocialUser.uid

  authenticatedCharacterKey = "authenticated_character_#{ socialId }"

  currentCharacter = null

  redis = request.redis
  db = request.db

  # Шаги:
  # 1) Ищем персонажа в редисе
  # 2) Если не находим, то ищем в базе
  # 3) Если не находим, то создаем и добавляем в базу
  # 4) В случае успешного добавления в базу, добавляем в редис
  # 5) В случае успешного найденного пользователя в базе, добавляем в редис
  # 6) На любом этапе, в случае найденного персонажа, присваеваем к currentCharacter
  # и возвращаем null, как идентификатор того, что
  # ничего делать больше не надо и идем дальше по цепочке

  redis.get(authenticatedCharacterKey)
  .then((character)->

    if character
      currentCharacter = JSON.parse(character)
      currentCharacter.last_visited_at = Date.now() # присваеваем актуальное время

      null
    else # если небыл найден в редисе, то ищем в базе
      Character.fetchForRead(db, social_id: socialId, 'oneOrNone')
  )
  .then((character)->
    if currentCharacter
      null

    else if character # если был найден в базе, то сохраняем в редисе
      currentCharacter = _.pick(character, CHARACTER_FIELDS)
      currentCharacter.last_visited_at = Date.now() # присваеваем актуальное время

      addToRedis(redis, authenticatedCharacterKey, currentCharacter)

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
    if currentCharacter
      null

    else # если игрок был сохранен в базу, то сохраняем его в редисе
      currentCharacter = _.pick(character, CHARACTER_FIELDS)

      currentCharacter.last_visited_at = Date.now() # присваеваем актуальное время

      addToRedis(redis, authenticatedCharacterKey, currentCharacter)

      null
  )
  .then(-> # последний шаг в цепочке, вызываем колбек и возвращаем текущего пользователя
    error = (
      if currentCharacter
        null
      else
        new Error("Character authenticated error: can't create OR found character")
    )

    callback(error, currentCharacter)
  )
  .catch((error)->
    callback(error, null)
  )

module.exports = (req, res, next)->
  # TODO определение платформы здесь

  req.currentSocialUser = req.currentOkUser || req.currentOfflineUser

  if req.currentSocialUser?.isAuthenticated()
    middleware(req, (error, currentCharacter)->
      if error
        res.sendEventError(error)
      else
        req.currentCharacter = currentCharacter

        next()
    )

  else
    res.sendEvent('not_authenticated')