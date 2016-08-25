chaiAsPromised = require 'chai-as-promised'
chai = require 'chai'
chai.use chaiAsPromised
expect = chai.expect

HDKey = require 'hdkey'
Document = require '../lib/document'
Custodian = require '../lib/custodian'
Definition = require '../lib/definition'
HealthProfile = require './fixtures/health'

bs = require 'bs58check'

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

    @definition = Definition(@custodian, HealthProfile)
    @definition.save().then (hash) => @definitionHash = hash

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
      expect(result).to.eventually.equal(bs.encode(@definitionHash))

    it 'should return a Definition', ->
      document = @newDocument(@privateExtendedKey)
      result = document.definition(HealthProfile).then -> document.definition()
      expect(result).to.eventually.be.an.instanceOf(Definition)

  describe 'validate', ->
    it 'should set errors attribute on invalid data', ->
      document = @newDocument(@privateExtendedKey)
      result = document.definition(HealthProfile)
      .then -> document.data({})
      .then -> document.validate()
      .catch -> document.errors
      expect(result).to.eventually.not.be.empty

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
        document0.data(name: 'Rupert').then ->
          document0.save().then ->
            document1.fetch().then (envelope) ->
              document1.data()

      expect(result).to.eventually.deep.equal(name: 'Rupert')

