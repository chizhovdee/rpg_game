exports.register = ->
  _.mixin(
    seconds: (seconds)-> seconds * 1000
    minutes: (minutes)-> minutes * 60 * 1000
    hours: (hours)-> hours * 60 * 60 * 1000

    addUniq: (arr, value)->
      arr.push(value) unless value in arr
  )