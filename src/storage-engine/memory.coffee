defer = require 'when'
bs = require 'bs58check'

class MemoryStorageEngine
  constructor: (@config) ->

  document:
    documents: {}
    get: (key) ->
      value = @documents[bs.encode(key)]
      if value? then defer(bs.decode(value))
      else defer.reject Error('Record not found')
    put: (key, value) -> @documents[bs.encode(key)] = bs.encode(value)

  data:
    data: {}
    get: (key) ->
      value = @data[bs.encode(key)]
      if value? then defer(bs.decode(value))
      else defer.reject Error('Record not found')
    put: (key, value) -> @data[bs.encode(key)] = bs.encode(value)

exports = module.exports = MemoryStorageEngine
