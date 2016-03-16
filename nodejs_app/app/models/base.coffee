_ = require('lodash')

class Base
  @dbTableName = null # здесь хранится имя таблицы, если не задано, то имя берется в качестве названия класса

  isChanged: false
  changed: null # массив изменненных полей
  changes: null # объект изменненный полей со старым и новым значением
  dbFields: null # массив атрибутов переданных из таблицы бд

  @include: (obj) ->
    throw new Error('include(obj) requires obj') unless obj
    for key, value of obj when key not in ['included']
      @::[key] = value
    obj.included?.apply(this)
    this

  @getDBTableName: ->
    _.snakeCase(@name) + "s"

  # for method argument see pg promise db methods
  @fetchForRead: (db, where, method = 'one')->
    db[method]("""select * from #{ @getDBTableName() }
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
    @dbFields = []

    for field, value of dbAttributes
      @dbFields.push(field)

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

  create: (db, timestamps = true)->
    if timestamps
      @created_at = @updated_at = new Date()
      @dbFields.push('created_at')
      @dbFields.push('updated_at')

    db.one("""
      insert into #{ @.getDBTableName() }(#{ @dbFields.join(', ') })
                    values(#{ @dbFields.map((f)-> "${#{ f }}").join(', ') })
                    returning *
    """, @)

  update: (db, timestamps = true)->
    @updated_at = new Date() if timestamps

    db.one("""
        update #{ @.getDBTableName() }
        set #{ @changed.map((field)-> "#{field}=${#{ field }}").join(', ') }
        where id=${id} returning *
    """, @) if @isChanged

  getDBTableName: ->
    @constructor.getDBTableName()

module.exports = Base