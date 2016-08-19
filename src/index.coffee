Custodian = require './custodian'
Definition = require './definition'

Wallet = require './wallet'
Document = require './document'
Collection = require './collection'

class YouBase
  constructor: (@custodian='api.youbase.io') ->
    if !(@ instanceof YouBase) then return new YouBase(@custodian)

    @custodian = Custodian(@custodian) if (typeof @custodian is 'string')

  wallet: -> new Wallet(@custodian, arguments...)

YouBase.Custodian = Custodian
YouBase.Definition = Definition

YouBase.Wallet = Wallet
YouBase.Document = Document
YouBase.Collection = Collection

exports = module.exports = YouBase
