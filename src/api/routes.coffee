msgpack = require('msgpack5')()
express = require 'express'
bs = require 'bs58check'

routes = (custodian) ->
  router = express.Router()

  # Info
  router.get '/info', (req, res, next) ->
    res.json
      version: custodian.version

  # Datastore
  router.post '/data', (req, res, next) ->
    custodian.data.put(req.body).then (hash) =>
      res.setHeader('Location', "/data/#{bs.encode(hash)}")
      res.status(201)
      res.json bs.encode(hash)
    .catch (err) => res.status(500).json(status: 500)

  router.get '/data/:id', (req, res, next) ->
    custodian.data.get(bs.decode(req.params.id))
    .then (data) =>
      res.setHeader('Cache-Control', 'public, max-age=31557600')
      res.json(data)
    .catch (err) => res.status(404).json(status: 404)

  # Documentstore
  router.post '/document', (req, res, next) ->
    custodian.document.put(JSON.stringify(req.body), 'json').then (id) =>
      res.setHeader('Location', "/document/#{bs.encode(id)}")
      res.status(201)
      res.json bs.encode(id)
    .catch (err) => res.status(500).json(status: 500, err: err.stack)

  router.get '/document/:id', (req, res, next) ->
    custodian.document.get(req.params.id, 'json')
    .then (data) => res.json(JSON.parse(data))
    .catch (err) => res.status(404).json(status: 404)

  router

module.exports = routes
