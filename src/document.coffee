_ = require 'lodash'
bs = require 'bs58check'
ecc = require 'ecc-tools'
tv4 = require 'tv4'
defer = require 'when'

HDKey = require 'hdkey'
Envelope = require 'ecc-envelope'
Collection = require './collection'
Definition = require './definition'

class Document
  constructor: (@custodian, key) ->
    if !(@ instanceof Document) then return new Document(@custodian, key)
    key = bs.decode(key) if (typeof key is 'string')

    @extended = false
    if key.length == 78
      @extended = true
      @hdkey = HDKey.fromExtendedKey(bs.encode(key))
      @privateKey = @hdkey.privateKey
      @publicKey = @hdkey.publicKey
      @children = new Collection(@custodian, Document, @hdkey.privateExtendedKey ? @hdkey.publicExtendedKey)
    else if key.length == 33
      @publicKey = key
    else if key.length == 32
      @privateKey = key
      @publicKey = ecc.publicKey(@privateKey)

    @readonly = !@privateKey?
    @_headers =
      from: bs.encode(@publicKey)
    @_links = {}

  fetch: ->
    @custodian.index.get(@publicKey).then (envelope) =>
      return false unless envelope
      envelope = Envelope(decode: envelope)
      envelope.open().then (envelope) =>
        @_meta = envelope.data.meta
        @_links = envelope.data.links
        @_headers = envelope.data.headers
        envelope

  link: (key, data) ->
    if data?
      @custodian.data.put(data)
      .then (hash) => @_links[key] = hash
    else @custodian.data.get(@_links[key])

  definition: (definition) ->
    if definition?
      return defer(false) if @readonly
      Definition(@custodian, definition).save().then (hash) => @_links.definition = hash
    else defer Definition(@custodian, @_links.definition)

  data: (data) ->
    if data?
      return false if @readonly
      @link('data', data)
    else @link('data')

  validate: ->
    @definition()
    .then (definition) -> definition.get('schema')
    .then (schema) =>
      @data().then (data) =>
        validation = tv4.validateMultiple(data, schema, false, true)
        @errors = validation.errors
        if validation.valid then data
        else defer.reject Error('Data does not match schema')

  meta: ->
    @definition()
    .then (definition) -> definition.get('meta')
    .then (meta) =>
      @data().then (data) =>
        @_meta = _.mapValues meta, (path) -> _.get(data, path)

  save: ->
    return defer(false) if @readonly
    @validate().then => @meta()
    .then (meta) =>
      @_envelope = Envelope
        send:
          meta: @_meta
          links: @_links
          headers: @_headers
        from: @privateKey

      @custodian.index.put @_envelope.encode('base64')

exports = module.exports = Document

