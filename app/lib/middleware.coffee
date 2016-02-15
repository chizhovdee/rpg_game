EventResponse = require('../lib/event_response')
util = require('util')
_ = require('lodash')

module.exports =
   ensureLogin: (req, res, next)->
     if req.user || req.path == '/login'
       next()

     else
       res.sendEventError(null, 'character_not_authorized')

   eventResponse: (req, res, next)->
     res.eventResponse ?= new EventResponse()

     res.addEvent = (type, callback)->
       @eventResponse.add(type, callback)

     res.sendEvents = ->
       @.json(@eventResponse.all())

     res.sendEvent = (type, callback)->
       @.addEvent(type, callback)

       @.sendEvents()

     res.sendEventError = (error, type = '')->
       type = 'server_error' if type == ''

       @eventResponse.add(type, (data)->
         data.error = error
       )

       @.sendEvents()

     next()

   apiRequestParamsLog: (req, res, next)->
     # TODO if env == 'development'

     unless _.isEmpty(req.body)
       console.log("Body Request", util.inspect(req.body,
         depth: null
       ))

     unless _.isEmpty(req.params)
       console.log("Body Params", util.inspect(req.params,
         depth: null
       ))


     next()

