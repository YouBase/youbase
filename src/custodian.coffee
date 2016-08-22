ecc = require 'ecc-tools'

defer = require('when')
_ = require('lodash')

rest = require('rest')
mime = require('rest/interceptor/mime')
client = rest.wrap(mime)

Datastore = require './datastore'
Documentstore = require './documentstore'

class Custodian
  constructor: (@config) ->
    if !(@ instanceof Custodian) then return new Custodian(@config)

    @data = new Datastore(@dataDB)
    @document = new Documentstore(@documentDB)

exports = module.exports = Custodian
