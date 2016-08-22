express = require 'express'

routes = (youbase) ->
  router = express.Router()

  # Info
  router.get '/info', (req, res, next) ->
    res.json
      version: youbase.version

  # Datastore
  router.post '/data', (req, res, next) ->
    youbase.data.put(req.body).then (hash) =>
      res.setHeader('Location', "/data/#{hash}")
      res.status(201)
      res.json hash
    .catch (err) => res.status(500).json(err)

  router.get '/data/:id', (req, res, next) ->
    youbase.data.get(req.params.id)
    .then (data) =>
      res.setHeader('Cache-Control', 'public, max-age=31557600')
      res.json(data)
    .catch (err) =>
      if err.notFound
        res.status(404).json()

  # Documentstore
  router.post '/document', (req, res, next) ->
    youbase.document.put(req.body).then (id) =>
      res.setHeader('Location', "/document/#{id}")
      res.status(201)
      res.json id
    .catch (err) => res.status(500).json(status: 500)

  router.get '/document/:id', (req, res, next) ->
    youbase.document.get(req.params.id)
    .then (data) => res.json(data)
    .catch (err) =>
      if err.notFound
        res.status(404).json()

  router

module.exports = routes
