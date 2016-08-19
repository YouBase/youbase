Wallet = require '../lib/wallet'
Custodian = require '../lib/memory-custodian'
Collection = require '../lib/collection'

expect = require('chai').expect
_ = require('lodash')

describe 'Wallet', ->
  before ->
    @validMnemonic = 'travel awake spin pony decide disorder swallow wait napkin panther mad crash'
    @invalidMnemonic = 'invalid'

    @profileData = {
      type: 'health'
    }

    @custodian = Custodian()

    @newWallet = (mnemonic) -> new Wallet(@custodian, mnemonic)
    @validWallet = _.partial(@newWallet, @validMnemonic)

  describe 'mnemonic', ->
    it 'should not error on a valid mnemonic', ->
      expect => @newWallet(@validMnemonic)
      .to.not.throw(Error)

    it 'should error on an invalid mnemonic', ->
      expect => @newWallet(@invalidMnemonic)
      .to.throw(Error)

  describe 'profiles', ->
    it 'should be a collection', ->
      result = @validWallet()
      expect(result.profiles).to.be.an.instanceOf(Collection)
