_ = require 'lodash'
ecc = require 'ecc-tools'
defer = require 'when'

class Datastore
  constructor: (@_db) ->
    @_db ?=
      documents: {}
      get: (key) -> @documents[key]
      put: (key, value) -> @documents[key] = value

  put: (data) ->
    defer(data).then (data) =>
      hash = ecc.bs58check.encode(ecc.checksum(data))
      defer(@_db.put(hash, data))
      .then ->hash

  get: (hash) -> defer(hash).then (hash) => @_db.get(hash)

module.exports = Datastore
