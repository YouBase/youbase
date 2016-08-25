bs = require 'bs58check'
defer = require 'when'
deferObject = require 'when/keys'

HDKey = require 'hdkey'
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
      Definition(@custodian, definition).save()
      .then (hash) => @_definitions[key] = bs.encode(hash)
    else if key?
      key = @_definitions[key] if (typeof key is 'string' and key.length <= 32)
      Definition(@custodian, key)
    else
      deferObject.map (@_definitions), (definition) =>
        Definition(@custodian, definition)

  insert: (definition, data, autosave=true) ->
    return false if @readonly
    document = @at()
    document.data(data)
    .then => document.definition(@definition(definition))
    .then -> document.save() if autosave
    .then => @_documents[document.hdkey.index - @offset] = document

  at: (index=@_documents.length+@offset) ->
    document = @_documents[index-@offset]
    return document if document?

    hdkey = @hdkey.deriveChild(index)
    key = hdkey.privateExtendedKey ? hdkey.publicExtendedKey
    new @model(@custodian, key)

  all: (refresh) -> @sync(refresh).then => @_documents

  sync: (refresh=false) ->
    start = @offset
    start = start + @_documents.length if !refresh
    defer.iterate(
      (document) => @at(document.hdkey.index + 1)
      (document) => document.fetch().yield(false).else(true)
      (document) => @_documents[document.hdkey.index - @offset] = document
      @at(start)
    )

exports = module.exports = Collection
