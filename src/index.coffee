class YouBase
  constructor: (@custodian='http://api.youbase.io') ->
    if !(@ instanceof YouBase) then return new YouBase(@custodian)

    @custodian = YouBase.Custodian(storage: 'rest', url: @custodian) if (typeof @custodian is 'string')

  wallet: -> new YouBase.Wallet(@custodian, arguments...)
  document: -> new YouBase.Document(@custodian, arguments...)
  definition: -> new YouBase.Definition(@custodian, arguments...)
  collection: -> new YouBase.Collection(@custodian, YouBase.Document, arguments...)

YouBase.Custodian = require './custodian'
YouBase.Definition = require './definition'

YouBase.Wallet = require './wallet'
YouBase.Document = require './document'
YouBase.Collection = require './collection'

YouBase.Envelope = require 'ecc-envelope'

exports = module.exports = YouBase
