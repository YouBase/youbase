defer = require 'when'
deferNode = require 'when/node'
bs = require 'bs58check'
levelup = require 'levelup'
memdown = require 'memdown'
sublevel = require 'level-sublevel'

class LevelupStorageEngine
  constructor: (@config={}) ->
    @config.db ?= memdown
    @location = @config.location ? './youbase'
    @db = sublevel(levelup(@config))
    @document = deferNode.liftAll(@db.sublevel('documents'))
    @data = deferNode.liftAll(@db.sublevel('data'))

exports = module.exports = LevelupStorageEngine
