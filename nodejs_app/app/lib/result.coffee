class Result
  errorCode: null
  data: null

  constructor: (options = {})->
    @errorCode = options.errorCode
    @data = options.data

  setErrorCode: (code)->
    @errorCode = code

  setData: (data)->
    @data = data

  isError: ->
    @errorCode?

module.exports = Result