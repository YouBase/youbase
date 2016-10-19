defer = require 'when'
bs = require 'bs58check'

url = require 'url'
request = require 'request'

class RestClient
  constructor: (@url, @auth) ->

  encoding: 'json'

  get: (key) ->
    defer.promise (resolve, reject) =>
      request url.resolve(@url, bs.encode(key)), {headers: {'content-type': 'application/json', 'auth': @auth}}, (err, res, body) =>
        if (!err && res.statusCode == 200) then resolve(JSON.parse(body))
        else reject(err)

  put: (key, value) ->
    defer.promise (resolve, reject) =>
      value = JSON.stringify(value) if (typeof value isnt 'string')
      request.post @url, {body: value, headers: {'content-type': 'application/json', 'auth': @auth}}, (err, res, body) ->
        if (!err && (res.statusCode == 201 || res.statusCode == 200)) then resolve(body)
        else reject(err)

class RestStorageEngine
  constructor: (@config) ->
    @url = @config.url
    @auth = @config.api_key
    @data = new RestClient(url.resolve(@url, 'data/'), @auth)
    @document = new RestClient(url.resolve(@url, 'document/'), @auth)

exports = module.exports = RestStorageEngine
