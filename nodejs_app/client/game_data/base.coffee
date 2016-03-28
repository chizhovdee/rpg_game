class Base extends Spine.Model
  @recordsByKey: {}

  @populate: (data)->
    @refresh(
      for values in data.values
        obj = {}

        for value, index in values
          obj[data.keys[index]] = value

        obj
    )

  @configure: ->
    @recordsByKey = {}

    super

  @addRecord: ->
    record = super

    @recordsByKey[record.key] = record.id

    record

  @deleteAll: ->
    super

    @recordsByKey = {}

  @find: (idOrKey, notFound = @notFound)->
    id = if _.isInteger(idOrKey)
      idOrKey
    else if (intId = _.toInteger(idOrKey)) && intId > 0
      intId
    else
      @recordsByKey[idOrKey]

    @irecords[id]?.clone() or notFound?.call(this, id)

  remove: ->
    super

    delete @constructor.recordsByKey[@key] if options.clear


module.exports = Base