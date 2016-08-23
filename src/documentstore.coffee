_ = require 'lodash'
ecc = require 'ecc-tools'
defer = require 'when'

Envelope = require 'ecc-envelope'

class Documentstore
  constructor: (@_db) ->
    @_db ?=
      documents: {}
      get: (key) -> @documents[key]
      put: (key, value) -> @documents[key] = value

  put: (envelope) ->
    defer(envelope).then (envelope) =>
      envelope = Envelope(decode: envelope)
      envelope.open().then (data) =>
        if data
          key = data.from
          defer(@_db.put(ecc.bs58check.encode(key), envelope.encode('base64')))
          .then -> key
        else false

  get: (key) -> defer(key).then (key) => @_db.get(ecc.bs58check.encode(key))

module.exports = Documentstore
