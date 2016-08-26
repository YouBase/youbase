chaiAsPromised = require 'chai-as-promised'
chai = require 'chai'
chai.use chaiAsPromised
expect = chai.expect

MemoryEngine = require '../lib/storage-engine/memory'
Datastore = require '../lib/datastore'

bs = require 'bs58check'

describe 'Datastore', ->
  before ->
    @storage = new MemoryEngine()
    @datastore = new Datastore(@storage.data)

    @data = {hello: 'world'}
    @hash = '28274LepaARxynterwnve1jB4rARDUgvHCYgPa4BECydUYz8qr'

  describe 'put', ->
    it 'should take an object and return a promise', ->
      result = @datastore.put(@data)
      expect(result).to.respondTo('then')

    it 'should resolve with a hash', ->
      result = @datastore.put(@data).then (hash) -> bs.encode(hash)
      expect(result).to.eventually.equal(@hash)

    it 'should store the json in the db', ->
      result = @datastore.put(@data)
      .then (hash) => @datastore.get(hash)

      expect(result).to.eventually.eql(@data)

  describe 'get', ->
    it 'should take a hash and return data', ->
      result = @datastore.put(@data).then (hash) =>
        @datastore.get(hash)
      expect(result).to.eventually.eql(@data)



