Custodian = require '../lib/memory-custodian'
Definition = require '../lib/definition'
HealthProfile = require './fixtures/health'

chaiAsPromised = require 'chai-as-promised'
chai = require 'chai'
chai.use chaiAsPromised
expect = chai.expect

describe 'Definition', ->
  before ->
    @custodian = new Custodian()
    @newDefinition = (definition) -> Definition(@custodian, definition)

  describe 'constructor', ->
    it 'should accept a Definition instance', ->
      definition0 = @newDefinition(HealthProfile)
      definition1 = @newDefinition(definition0)
      expect(definition1).to.equal(definition0)

    it 'should accept an object definition', ->
      definition = @newDefinition(HealthProfile)
      expect(definition).to.be.an.instanceOf(Definition)

  describe 'children', ->
    it 'should return an object', ->
      definition = @newDefinition(HealthProfile)
      result = definition.children()
      expect(result).to.be.an.object

  describe 'toObject', ->
    it 'should return an object', ->
      definition = @newDefinition(HealthProfile)
      result = definition.toObject().then (value) ->
      expect(result).to.be.an.object

