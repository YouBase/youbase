_ = require 'lodash'
ecc = require 'ecc-tools'
bs = require 'bs58check'
defer = require 'when'

class Datastore
  constructor: (@_store) ->
    if !(@ instanceof Datastore) then return new Datastore(@_store)

  put: (data) ->
    defer(data).then (data) =>
      hash = ecc.checksum(data)
      defer(@_store.put(hash, data))
      .then -> hash

  get: (hash) ->
    defer(hash)
    .then (hash) =>
      hash = bs.decode(hash) if (typeof hash is 'string')
      @_store.get(hash)
    .then (data) -> data

module.exports = Datastore
