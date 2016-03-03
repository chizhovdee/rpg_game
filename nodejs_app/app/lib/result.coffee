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

  toJSON: ->
    {
      is_error: @.isError()
      errorCode: @errorCode
      data: @data
    }

module.exports = Result