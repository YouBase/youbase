_ = require 'lodash'
bs = require 'bs58check'
ecc = require 'ecc-tools'
defer = require 'when'

Envelope = require 'ecc-envelope'

class Documentstore
  constructor: (@_store) ->
    if !(@ instanceof Documentstore) then return new Documentstore(@_store)

  put: (envelope) ->
    defer(envelope).then (envelope) =>
      envelope = Envelope(decode: envelope)
      envelope.open().then (data) =>
        if data
          key = data.from
          envelope.encode().then (value) =>
            @_store.put(key, value)
          .then -> key
        else false

  get: (key) ->
    defer(key)
    .then (key) =>
      key = bs.decode(key) if (typeof key is 'string')
      @_store.get(key)
    .then (data) -> Buffer.from(data)

module.exports = Documentstore
