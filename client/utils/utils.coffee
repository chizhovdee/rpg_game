_ = require("underscore")

utils =
  deepClone: (obj, excludesAttributes...)->
    if _.isObject(obj)
      if _.isArray(obj)
        @.cloneArray(obj)
      else
        @.clone(obj, excludesAttributes...)
    else
      obj

  clone: (obj, excludesAttributes...)->
    newObj = {}

    for key, value of obj
      continue if key in excludesAttributes

      if _.isObject(value)
        newObj[key] = if _.isArray(value) then @.cloneArray(value) else @.clone(value)
      else
        newObj[key] = value

    newObj

  cloneArray: (arr)->
    newArr = []

    for value in arr
      if _.isObject(value)
        newArr.push(if _.isArray(value) then @.cloneArray(value) else @.clone(value))
      else
        newArr.push(value)

    newArr

module.exports = utils