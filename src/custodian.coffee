Datastore = require './datastore'
Documentstore = require './documentstore'

StorageEngines =
  levelup: 
    -> require './storage-engine/levelup'
  memory: 
    -> require './storage-engine/memory'
  rest: 
    -> require './storage-engine/rest'

class Custodian
  constructor: (@config={}) ->
    if !(@ instanceof Custodian) then return new Custodian(@config)

    storageEngine = @config?.storage ? 'memory'
    storageEngine = StorageEngines[storageEngine]() if (typeof storageEngine is 'string')
    @store = new storageEngine(@config)

    @data = new Datastore(@store.data)
    @document = new Documentstore(@store.document)

exports = module.exports = Custodian
