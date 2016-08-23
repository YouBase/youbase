_ = require 'lodash'
ecc = require 'ecc-tools'

chaiAsPromised = require 'chai-as-promised'
chai = require 'chai'
chai.use chaiAsPromised
expect = chai.expect

Documentstore = require '../src/documentstore'
Envelope = require 'ecc-envelope'

describe 'Documentstore', ->
  before ->
    @documentstore = new Documentstore()

    @privateKey = ecc.privateKey()
    @publicKey = ecc.publicKey(@privateKey, true)
    @envelope = Envelope(send: {hello: 'world'}, from: @privateKey)

  describe 'put', ->
    it 'should allow me to put an envelope and get a the key', ->
      result = @documentstore.put(@envelope.encode())
      expect(result).to.eventually.deep.equal(@publicKey)

  describe 'get', ->
    it 'should allow me to get an envelope from the key', ->
      result = @documentstore.get(@publicKey)
      @envelope.encode('base64').then (envelope) ->
        expect(result).to.eventually.equal(envelope)
