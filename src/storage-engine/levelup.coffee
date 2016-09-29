_ = require 'lodash'
defer = require 'when'
deferNode = require 'when/node'
bs = require 'bs58check'
levelup = require 'levelup'
memdown = require 'memdown'
sublevel = require 'level-sublevel'

class LevelupStorageEngine
  constructor: (@config={}) ->
    @config.db ?= memdown
    @config.valueEncoding = 'json'
    @location = @config.location ? './youbase'
    @db = sublevel(levelup(@config))
    @document = _.merge({}, deferNode.liftAll(@db.sublevel('documents')), {encoding: 'json'})
    @data = _.merge({}, deferNode.liftAll(@db.sublevel('data')), {encoding: 'json'})

exports = module.exports = LevelupStorageEngine
