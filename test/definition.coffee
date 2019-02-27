Custodian = require '../src/custodian'
Definition = require '../src/definition'
HealthProfile = require './fixtures/health'

chaiAsPromised = require 'chai-as-promised'
chai = require 'chai'
chai.use chaiAsPromised
expect = chai.expect

describe 'Definition', ->
  before ->
    @custodian = new Custodian()
    @newDefinition = (definition) -> new Definition(@custodian, definition)

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

  describe 'get', ->
    it 'should return an object', ->
      definition = @newDefinition(HealthProfile)
      result = definition.get()
      expect(result).to.be.an.object

    it 'should return the related section when passed a key', ->
      definition = @newDefinition(HealthProfile)
      result = definition.get('meta')
      expect(result).to.eventually.deep.equal({name: "name", age: "age"})

