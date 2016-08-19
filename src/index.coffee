Wallet = require('./wallet')
Custodian = require('./custodian')

class YouBase
  constructor: (@custodian='api.youbase.io') ->
    if !(@ instanceof YouBase) then return new YouBase(@custodian)

    @custodian = Custodian(@custodian) if (typeof @custodian is 'string')

  wallet: -> new Wallet(@custodian, arguments...)

exports = module.exports = YouBase
