_ = require('lodash')
Result = require('../result')

module.exports = (req, res, next)->
  # находит объект класса Result и возвращает его
  res.parseResult = (result)->
    if _.isArray(result)
      for r in result
        if r instanceof Result
          return r
    else
      result if result instanceof Result

  next()