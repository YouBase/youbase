HDKey = require 'hdkey'
Document = require '../lib/document'
Custodian = require '../lib/memory-custodian'
Definition = require '../lib/definition'
HealthProfile = require './fixtures/health'

chaiAsPromised = require 'chai-as-promised'
chai = require 'chai'
chai.use chaiAsPromised
expect = chai.expect

describe 'Document', ->
  before ->
    @privateExtendedKey = 'xprv9s21ZrQH143K2jzgJNDNFpkbyC1oUmuBkgp7BZtvk1QUu4McmfWMdfzWqXCThRY8zPZh5p2CsKi9dg2m6YmkfL9QtRDL7UBZcth5BpmKDrb'
    @publicExtendedKey = 'xpub661MyMwAqRbcFE59QPkNcxhLXDrHtEd37ujhyxJYJLwTmrgmKCpcBUJzgooMPHKFQ9mRUR9ytCYathfEdEFLMR9xzGFNaRfDdpcBWv1cV9j'

    @hdkey = HDKey.fromExtendedKey(@privateExtendedKey)
    @privateKey = @hdkey.privateKey
    @publicKey = @hdkey.publicKey

    @invalidExtendedKey = 'invalid'

    @custodian = new Custodian()
    @newDocument = (key) -> Document(@custodian, key)

    @definitionHash = '2Anmw2Nzc2wkkbM7JjnftbQaLKXdm2uMs1XXCbNkp1ERKEPT5p'

  describe 'extended', ->
    it 'should be extended if passed an extended public key', ->
      document = @newDocument(@publicExtendedKey)
      expect(document.extended).to.be.true

    it 'should be extended if passed an extended private key', ->
      document = @newDocument(@privateExtendedKey)
      expect(document.extended).to.be.true

    it 'should not be extended if passed an extended private key', ->
      document = @newDocument(@privateKey)
      expect(document.extended).to.be.false

  describe 'readonly', ->
    it 'should be readonly if passed an extended public key', ->
      document = @newDocument(@publicExtendedKey)
      expect(document.readonly).to.be.true

    it 'should not be readonly if passed an extended private key', ->
      document = @newDocument(@privateExtendedKey)
      expect(document.readonly).to.be.false

  describe 'link', ->
    it 'should save a link to custodian.data', ->
      document = @newDocument(@privateExtendedKey)
      result = document.link('body', {hello: 'world'}).then (hash) ->
        document.custodian.data.get(hash)
      expect(result).to.eventually.deep.equal({hello: 'world'})

    it 'should return saved data', ->
      document = @newDocument(@privateExtendedKey)
      result = document.link('body', {hello: 'world'}).then (hash) ->
        document.link('body')
      expect(result).to.eventually.deep.equal({hello: 'world'})

  describe 'definition', ->
    it 'should take a definition and return a hash', ->
      document = @newDocument(@privateExtendedKey)
      result = document.definition(HealthProfile)
      expect(result).to.eventually.equal(@definitionHash)

    it 'should return a Definition', ->
      document = @newDocument(@privateExtendedKey)
      result = document.definition(HealthProfile).then -> document.definition()
      expect(result).to.eventually.be.an.instanceOf(Definition)

  describe 'meta', ->
    it 'should extract metadata from data', ->
      document = @newDocument(@privateExtendedKey)
      result = document.definition(HealthProfile)
        .then => document.data({name: 'hello', age: 25, gender: 'F'})
        .then => document.meta()
      expect(result).to.eventually.deep.equal({name: 'hello', age: 25})

  describe 'save', ->
    it 'should save _data to the custodian', ->
      document0 = @newDocument(@privateExtendedKey)
      document1 = @newDocument(@privateExtendedKey)
      result = document0.definition(HealthProfile).then ->
        document0.data(hello: 'world').then ->
          document0.save().then ->
            document1.fetch().then (envelope) ->
              document1.data()

      expect(result).to.eventually.deep.equal(hello: 'world')

