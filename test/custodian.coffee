chaiAsPromised = require 'chai-as-promised'
chai = require 'chai'
chai.use chaiAsPromised
expect = chai.expect

Custodian = require '../src/custodian'
Envelope = require 'ecc-envelope'

_ = require 'lodash'
bs = require 'bs58check'
ecc = require 'ecc-tools'

describe 'Custodian', ->
  before ->
    @custodian = new Custodian()
    @barHash = bs.decode('aYSAd13fa7mzsguAoaXnecLfpTDKziwQ4BN2r3QLdi4QcLVZZ')

  describe 'data', ->
    it 'should allow me to put a value and get a the hash', ->
      result = @custodian.data.put('bar')
      expect(result).to.eventually.deep.equal(@barHash)

    it 'should allow me to get a value from the hash', ->
      result = @custodian.data.get(@barHash)
      expect(result).to.eventually.equal('bar')

  describe 'document', ->
    before ->
      @privateKey = ecc.privateKey()
      @publicKey = ecc.publicKey(@privateKey, true)
      @envelope = Envelope(send: {hello: 'world'}, from: @privateKey)

    it 'should allow me to put a value and get a the key', ->
      result = @custodian.document.put(@envelope.encode())
      expect(result).to.eventually.deep.equal(@publicKey)

    it 'should allow me to get a value from the key', ->
      result = @custodian.document.get(@publicKey)
      @envelope.encode().then (envelope) ->
        expect(result).to.eventually.deep.equal(envelope)
