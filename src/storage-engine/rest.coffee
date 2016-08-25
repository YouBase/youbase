defer = require 'when'
bs = require 'bs58check'

url = require 'url'
request = require 'request'

class RestClient
  constructor: (@url) ->

  get: (key) ->
    defer.promise (resolve, reject) =>
      request url.resolve(@url, bs.encode(key)), {encoding: null}, (err, res, body) =>
        if (!err && res.statusCode == 200) then resolve(body)
        else reject(err)

  put: (key, value) ->
    defer.promise (resolve, reject) =>
      request.post @url, {body: value, headers: {'content-type': 'application/octet-stream'}, encoding: null}, (err, res, body) ->
        if (!err && res.statusCode == 201) then resolve(body)
        else reject(err)

class RestStorageEngine
  constructor: (@config) ->
    @url = @config.url
    @data = new RestClient(url.resolve(@url, 'data/'))
    @document = new RestClient(url.resolve(@url, 'document/'))

exports = module.exports = RestStorageEngine
