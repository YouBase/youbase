_ = require 'lodash'
bs = require 'bs58check'
ecc = require 'ecc-tools'
tv4 = require 'tv4'
defer = require 'when'
crypto = require 'crypto'

HDKey = require 'hdkey'
Envelope = require 'ecc-envelope'
Collection = require './collection'
Definition = require './definition'

ScarDefinition =
  permissions: 'public'
  meta: {}
  form: {}
  schema:
    title: 'Scar'
    type: 'object'
  children: {}

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
      @publicKey = ecc.publicKey(@privateKey, true)

    @pub = bs.encode(@publicKey) if @publicKey
    @prv = bs.encode(@privateKey) if @privateKey
    @xpub = @hdkey?.publicExtendedKey
    @xprv = @hdkey?.privateExtendedKey

    @readonly = !@privateKey?
    @_headers =
      from: bs.encode(@publicKey)
    @_links = {}
    @fetch().else(false)

  fetch: ->
    @_fetch = @custodian.document.get(@publicKey)
    .then (envelope) =>
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
      .then (hash) => @_links[key] = bs.encode(new Buffer(hash))
    else @custodian.data.get(@_links[key])

  definition: (definition) ->
    if definition?
      return defer(false) if @readonly
      (@_definition = defer Definition(@custodian, definition))
      .then (definition) => definition.save()
      .then (hash) => @_links.definition = bs.encode(new Buffer(hash))
      .then => definition.children()
      .then (children) => @children._definitions = children
      .then => @_links.definition
    else @_definition ?= defer Definition(@custodian, @_links.definition)

  data: (data, alg='aes') ->
    if data?
      defer(data).then (data) =>
        return false if @readonly
        @encrypt(data, alg)
    else @decrypt()

  encrypt: (data, alg='aes') ->
    return defer(false) if @readonly
    @definition()
    .then (definition) -> definition.get('permissions')
    .then (permissions) =>
      if permissions == 'public' then @link('data', data)
      else if permissions == 'hardened' or permissions == 'private'
        return defer(false) if !@extended
        iv = crypto.randomBytes(16)
        key = ecc.sha256(@xpub) if permissions == 'hardened'
        key = ecc.sha256(@prv) if permissions == 'private'
        ecc.cipher(data, key, iv, 'aes').then (ciphertext) =>
          iv = bs.encode(iv)
          ciphertext = bs.encode(ciphertext)
          @link('data', {iv: iv, alg: alg, ciphertext: ciphertext})

  decrypt: ->
    @definition()
    .then (definition) -> definition.get('permissions')
    .then (permissions) =>
      @link('data').then (cipher) =>
        return cipher if permissions == 'public'
        key = ecc.sha256(@xpub) if permissions == 'hardened'
        key = ecc.sha256(@prv) if permissions == 'private'
        ciphertext = bs.decode(cipher.ciphertext)
        iv = bs.decode(cipher.iv)
        ecc.decipher(ciphertext, key, iv, cipher.alg)

  validate: ->
    @definition()
    .then (definition) -> definition.get('schema')
    .then (schema) =>
      @data().then (data) =>
        defer.reject Error("No data") unless data?
        validation = tv4.validateMultiple(data, schema, false)
        @errors = validation.errors
        if validation.valid then data
        else defer.reject Error("Data does not match schema: #{@errors}")

  meta: ->
    @definition()
    .then (definition) -> definition.get('meta')
    .then (meta) =>
      @data().then (data) =>
        @_meta = _(meta).mapValues((path) -> _.get(data, path)).omitBy(_.isUndefined).value()

  summary: ->
    @meta()
    .then (meta) =>
      meta: meta
      document: @

  details: ->
    @_fetch
    .then => @data()
    .then (data) =>
      data: data
      document: @

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

      @custodian.document.put @_envelope.encode()

  redact: ->
    @children.all(true, 'redact')
    .then => @definition(ScarDefinition)
    .then => @data({})
    .then => @save()

exports = module.exports = Document

