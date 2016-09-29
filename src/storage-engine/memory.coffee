defer = require 'when'
bs = require 'bs58check'

class MemoryStorageEngine
  constructor: (@config) ->

  document:
    documents: {}
    get: (key) ->
      value = @documents[bs.encode(key)]
      if value? then defer(bs.decode(value))
      else defer.reject Error('Document not found')
    put: (key, value) ->
      @documents[bs.encode(key)] = bs.encode(value)

  data:
    data: {}
    get: (key) ->
      value = @data[bs.encode(key)]
      if value? then defer(value)
      else defer.reject Error('Data not found')
    put: (key, value) -> @data[bs.encode(key)] = value

exports = module.exports = MemoryStorageEngine
