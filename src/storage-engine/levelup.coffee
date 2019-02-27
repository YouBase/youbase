_ = require 'lodash'
deferNode = require 'when/node'
levelup = require 'levelup'
memdown = require 'memdown'
encode = require 'encoding-down'
sublevel = require 'level-sublevel'

class LevelupStorageEngine
  constructor: (@config={}) ->
    @config.valueEncoding = 'json'
    if !@config.db
      @config.db = memdown()
      console.log 'Data will not be persisted'
    else if (typeof @config.db == 'string')
      leveldown = require('leveldown')
      @location = @config.db
      @config.db = leveldown(@location)
      if @config.cleardb
        leveldown.destroy @config.dblocation, ->  console.log 'data cleared: ' + @location

    @db = sublevel(levelup(encode(@config.db)))
    @document = _.merge({}, deferNode.liftAll(@db.sublevel('documents')), {encoding: 'json'})
    @data = _.merge({}, deferNode.liftAll(@db.sublevel('data')), {encoding: 'json'})

exports = module.exports = LevelupStorageEngine
