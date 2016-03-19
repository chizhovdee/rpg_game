_ = require("lodash")

exports.register = ->
  _.mixin(
    seconds: (seconds)-> seconds * 1000
    minutes: (minutes)-> minutes * 60 * 1000
    hours: (hours)-> hours * 60 * 60 * 1000

    addUniq: (arr, value)->
      arr.push(value) unless value in arr

    parseRequestParams: (params, options = {})->
      result = {}

      parseValues = if options.parse_values? then options.parse_values else false

      for key, value of params
        # все числа в строках приводим к обычным числам
        if parseValues
          if _.isArray(value)
            for v, index in value
              _v = _.toNumber(v)
              value[index] = _v unless _.isNaN(_v)
          else
            _value = _.toNumber(value)
            value = _value unless _.isNaN(_value)

        _.setWith(result, key, value)

      result
  )