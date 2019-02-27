bs = require 'bs58check'
defer = require 'when'
deferObject = require 'when/keys'

HDKey = require 'hdkey'
HDName = require 'hdname'
Definition = require './definition'

HARDENED_OFFSET = 0x80000000

class Collection
  constructor: (@custodian, @model, key, @hardened=false) ->
    if !(@ instanceof Collection) then return new Collection(@custodian, @model, key, @hardened)

    key = bs.decode(key) if (typeof key is 'string')

    @hdkey = HDKey.fromExtendedKey(bs.encode(key))
    @privateKey = @hdkey.privateKey
    @publicKey = @hdkey.publicKey

    @readonly = !@privateKey?

    if @hardened then @offset = HARDENED_OFFSET
    else @offset = 0

    @_definitions = {}
    @_documents = []

  definition: (key, definition) ->
    if definition?
      new Definition(@custodian, definition).save()
      .then (hash) => @_definitions[key] = bs.encode(hash)
    else if key?
      key = @_definitions[key] if (typeof key is 'string' and key.length <= 32)
      new Definition(@custodian, key)
    else
      deferObject.map (@_definitions), (definition) =>
        new Definition(@custodian, definition)

  insert: (definition, data, autosave=true) ->
    return false if @readonly
    @sync().then =>
      document = @at()
      document.definition(@definition(definition))
      .then => document.data(data)
      .then -> document.save() if autosave
      .then => @_documents[document.hdkey.index - @offset] = document

  at: (index=@_documents.length+@offset) ->
    if !Array.isArray(index)
      document = @_documents[index-@offset]
      return document if document?

    index = HDName.encode(index) if (typeof index is 'string')
    hdkey = @derive(index)
    key = hdkey.privateExtendedKey ? hdkey.publicExtendedKey
    new @model(@custodian, key)

  derive: (index, key=@hdkey) ->
    if Array.isArray(index) then index.reduce ((m, i) => @derive(i,m)), key
    else key.deriveChild(index)

  all: (refresh, pluck) ->
    if (typeof refresh is 'string')
      pluck = refresh
      refresh = false
    @sync(refresh).then =>
      console.log 'all', @_documents.length
      if pluck then defer.map(@_documents, (d) -> d[pluck]?())
      else @_documents

  sync: (refresh=false) ->
    start = @offset
    start = start + @_documents.length if !refresh
    defer.iterate(
      (document) => @at(document.hdkey.index + 1)
      (document) => document.fetch().yield(false).else(true)
      (document) => @_documents[document.hdkey.index - @offset] = document
      @at(start)
    ).then => @

exports = module.exports = Collection
