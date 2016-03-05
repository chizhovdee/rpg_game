_ = require('lodash')

class Base
  @dbTableName = null # здесь хранится имя таблицы, если не задано, то имя берется в качестве названия класса

  isChanged: false
  changed: null # массив изменненных полей
  changes: null # объект изменненный полей со старым и новым значением

  @getDBTableName: ->
    _.snakeCase(@name) + "s"

  @fetchForRead: (db, where)->
    db.one("""select * from #{ @getDBTableName() }
      where #{ _.keys(where).map((field)-> "#{field}=${#{ field }}").join(', ') }
      limit 1""", where
    )

  @fetchForUpdate: (db, where)->
    db.one("""select * from #{ @getDBTableName() }
      where #{ _.keys(where).map((field)-> "#{field}=${#{ field }}").join(', ') }
      limit 1 for update""", where
    )

  constructor: (dbAttributes = {}, otherAttributes = {})->
    @changed = []
    @changes = {}

    for field, value of dbAttributes
      @.defineDBAttribute(field, value)

    _.assignIn(@, otherAttributes)

  defineDBAttribute: (field, value)->
    # определяем приватный невидимый аттрибут
    Object.defineProperty(@, "_#{ field }", writable: true, value: value)

    # публичный видимый аттрибут использующий невидимый, определенный выше
    Object.defineProperty(@, field,
      enumerable: true
      configurable: true
      get: -> @["_#{ field }"]

      set: (newValue)->
        return if @["_#{ field }"] == newValue

        @changes[field] = [@["_#{ field }"], newValue] # [old, new]

        @["_#{ field }"] = newValue

        _.addUniq(@changed, field)

        @isChanged = true

        @["_#{ field }"] # return new value
    )

  update: (db)->
    db.one("""
        update #{ @.getDBTableName() }
        set #{ @changed.map((field)-> "#{field}=${#{ field }}").join(', ') }
        where id=${id} returning *
    """, @) if @isChanged

  getDBTableName: ->
    @constructor.getDBTableName()

module.exports = Base