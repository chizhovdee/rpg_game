class Result
  errorCode: null
  data: null
  reload: false

  constructor: (options = {})->
    @errorCode = options.errorCode
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
      isError: @.isError()
      errorCode: @errorCode
      data: @data
      reload: @reload
    }

module.exports = Result