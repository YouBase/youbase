_ = require 'lodash'
deferNode = require 'when/node'
levelup = require 'levelup'
memdown = require 'memdown'
sublevel = require 'level-sublevel'

class LevelupStorageEngine
  constructor: (@config={}) ->
    @config.valueEncoding = 'json'
    if !@config.dblocation
    	@config.db = require 'memdown'
    	console.log 'Data will not be persisted'
    else if @config.cleardb
      require('leveldown').destroy @config.dblocation, -> 
        console.log 'data cleared: ' + @config.dblocation 
    @location = @config.dblocation ? ''
    @db = sublevel(levelup(@location, @config))
    @document = _.merge({}, deferNode.liftAll(@db.sublevel('documents')), {encoding: 'json'})
    @data = _.merge({}, deferNode.liftAll(@db.sublevel('data')), {encoding: 'json'})

exports = module.exports = LevelupStorageEngine
