_ = require 'lodash'
bs = require 'bs58check'
ecc = require 'ecc-tools'
defer = require 'when'

Envelope = require 'ecc-envelope'

class Documentstore
  constructor: (@_store) ->

  put: (envelope, encoding) ->
    defer(envelope).then (envelope) =>
      envelope = Envelope(decode: envelope, as: encoding)
      envelope.open().then (data) =>
        if data
          key = data.from
          envelope.encode(@_store.encoding).then (value) =>
            @_store.put(key, value)
          .then -> key
        else false

  get: (key, encoding) ->
    defer(key)
    .then (key) =>
      key = bs.decode(key) if (typeof key is 'string')
      @_store.get(key)
    .then (data) =>
      Envelope(decode: data, as: @_store.encoding).encode(encoding)

module.exports = Documentstore
