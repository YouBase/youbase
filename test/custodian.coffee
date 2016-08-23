_ = require 'lodash'
ecc = require 'ecc-tools'

chaiAsPromised = require 'chai-as-promised'
chai = require 'chai'
chai.use chaiAsPromised
expect = chai.expect

Custodian = require '../lib/custodian'
Envelope = require 'ecc-envelope'

describe 'Custodian', ->
  before ->
    @custodian = Custodian()

  describe 'data', ->
    it 'should allow me to put a value and get a the hash', ->
      result = @custodian.data.put('bar')
      expect(result).to.eventually.equal('aYSAd13fa7mzsguAoaXnecLfpTDKziwQ4BN2r3QLdi4QcLVZZ')

    it 'should allow me to get a value from the hash', ->
      result = @custodian.data.get('aYSAd13fa7mzsguAoaXnecLfpTDKziwQ4BN2r3QLdi4QcLVZZ')
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
      @envelope.encode('base64').then (envelope) ->
        expect(result).to.eventually.equal(envelope)
