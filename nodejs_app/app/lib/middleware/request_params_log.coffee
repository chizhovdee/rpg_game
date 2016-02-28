util = require('util')
_ = require('lodash')

module.exports = (req, res, next)->
  next()

  return if req.app.get('env') != 'development'

  unless _.isEmpty(req.body)
    console.log("Body Request", util.inspect(req.body,
      depth: null
    ))

  unless _.isEmpty(req.params)
    console.log("Body Params", util.inspect(req.params,
      depth: null
    ))

  unless _.isEmpty(req.query)
    console.log("Query Params", util.inspect(req.query,
      depth: null
    ))