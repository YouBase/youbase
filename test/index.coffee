YouBase = require('../lib/index')
Wallet = require('../lib/wallet')
Custodian = require('../lib/custodian')

expect = require('chai').expect
_ = require('lodash')

describe 'YouBase', ->
  before ->
    @validMnemonic = 'travel awake spin pony decide disorder swallow wait napkin panther mad crash'
    @privateExtendedKey = 'xprv9s21ZrQH143K2jzgJNDNFpkbyC1oUmuBkgp7BZtvk1QUu4McmfWMdfzWqXCThRY8zPZh5p2CsKi9dg2m6YmkfL9QtRDL7UBZcth5BpmKDrb'

  it 'should set a custodian', ->
    result = YouBase()
    expect(result.custodian).to.be.an.instanceOf(Custodian)

