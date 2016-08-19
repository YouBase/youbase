_ = require 'lodash'
defer = require 'when'
deferObject = require 'when/keys'

class Definition
  constructor: (@custodian, definition) ->
    if !(@ instanceof Definition) then return new Definition(@custodian, definition)
    if (definition instanceof Definition) then return definition
    if (typeof definition is 'object') then @_definition = defer(definition)
    if (typeof definition is 'string') then @_definition = @custodian.data.get(definition)

  child: (key) -> @children().then(children) -> Definition(@custodian, children[key])

  children: ->
    @_children ?= @_definition.then (definition) ->
      deferObject.map (definition.children ? {}), (child) ->
        Definition(@custodian, child).save()

  toObject: ->
    @_toObject ?= @_definition.then (definition) =>
      @children().then (children) =>
        permissions: definition.permissions ? 'public'
        meta: definition.meta ? {}
        form: definition.form ? {}
        schema: definition.schema ? {}
        children: children

  save: -> @custodian.data.put(@toObject())


exports = module.exports = Definition
