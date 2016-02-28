class SignatureKeeper
  _signature: null
  _signatureName: null

  constructor: ->
    if window.okSignedParams
      @.setSignature(window.okSignedParams)

      @_signatureName = 'signed_params'
    else if window.offlineSignedParams
      @.setSignature(window.offlineSignedParams)

      @_signatureName = 'signed_params'

  setSignature: (value)->
    @_signature = value

  getSignature: ->
    @_signature

  getSignatureName: ->
    @_signatureName

signatureKeeper = new SignatureKeeper()

module.exports = signatureKeeper