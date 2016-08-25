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
    custodian.data.put(msgpack.decode(req.body)).then (hash) =>
      res.setHeader('Location', "/data/#{bs.encode(hash)}")
      res.status(201)
      res.json hash
    .catch (err) => res.status(500).json(status: 500)

  router.get '/data/:id', (req, res, next) ->
    custodian.data.get(bs.decode(req.params.id))
    .then (data) =>
      res.setHeader('Cache-Control', 'public, max-age=31557600')
      res.setHeader('Content-Type', 'application/octet-stream')
      res.send(msgpack.encode(data))
    .catch (err) => res.status(404).json(status: 404)

  # Documentstore
  router.post '/document', (req, res, next) ->
    custodian.document.put(req.body).then (id) =>
      console.log 'POST Document', bs.encode(id)
      res.setHeader('Location', "/document/#{bs.encode(id)}")
      res.setHeader('Content-Type', 'application/octet-stream')
      res.status(201)
      res.send(id)
    .catch (err) => res.status(500).json(status: 500)

  router.get '/document/:id', (req, res, next) ->
    custodian.document.get(req.params.id)
    .then (data) =>
      console.log 'GET Document', data
      res.setHeader('Content-Type', 'application/octet-stream')
      res.send(data)
    .catch (err) => res.status(404).json(status: 404)

  router

module.exports = routes
