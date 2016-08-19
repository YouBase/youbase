Envelope = require 'ecc-envelope'
ecc = require 'ecc-tools'

defer = require('when')

class Datastore
  constructor: ->
    @_data = {}

  put: (data) ->
    defer(data).then (data) =>
      hash = ecc.bs58check.encode(ecc.checksum(data))
      @_data[hash] = data
      hash

  get: (hash) -> defer(hash).then (hash) => @_data[hash]

class Index
  constructor: ->
    @_index = {}

  put: (envelope) ->
    defer(envelope).then (envelope) =>
      envelope = Envelope(decode: envelope)
      envelope.open().then (data) =>
        if data
          key = data.from
          @_index[ecc.bs58check.encode(key)] = envelope.encode('base64')
          key
        else false

  get: (key) -> defer @_index[ecc.bs58check.encode(key)]

class Custodian
  constructor: (@config) ->
    if !(@ instanceof Custodian) then return new Custodian(@config)

    @data = new Datastore()
    @index = new Index()

exports = module.exports = Custodian
