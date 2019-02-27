YouBase = require('../src/index')
Wallet = require('../src/wallet')
Custodian = require('../src/custodian')

expect = require('chai').expect
_ = require('lodash')

describe 'YouBase', ->
  before ->
    @validMnemonic = 'travel awake spin pony decide disorder swallow wait napkin panther mad crash'
    @privateExtendedKey = 'xprv9s21ZrQH143K2jzgJNDNFpkbyC1oUmuBkgp7BZtvk1QUu4McmfWMdfzWqXCThRY8zPZh5p2CsKi9dg2m6YmkfL9QtRDL7UBZcth5BpmKDrb'

  it 'should set a custodian', ->
    result = new YouBase()
    expect(result.custodian).to.be.an.instanceOf(Custodian)

