class Result
  errorCode: null
  data: null
  reload: false

  constructor: (options = {})->
    @errorCode = options.error_code
    @data = options.data
    @reload = options.reload || false

  setErrorCode: (code)->
    @errorCode = code

  setData: (data)->
    @data = data

  isError: ->
    @errorCode?

  toJSON: ->
    {
      is_error: @.isError()
      error_code: @errorCode
      data: @data
      reload: @reload
    }

module.exports = Result