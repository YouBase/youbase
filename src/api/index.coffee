express = require 'express'

path = require 'path'
logger = require 'morgan'
bodyParser = require 'body-parser'

Custodian = require '../custodian'

api = (app, config) ->
  custodian = Custodian(storage: 'memory')

  routes = require('./routes')(custodian)

  app.use logger('dev')
  app.use bodyParser.json(type: 'application/json')
  app.use bodyParser.raw(type: 'application/octet-stream')

  app.use (req, res, next) ->
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept")
    next()

  # routes
  app.use '/', routes
  app.use express.static(__dirname + '/../../docs')
  app.use express.static(__dirname + '/../../dist')

  # catch 404 and forward to error handler
  app.use (req, res, next) ->
    err = new Error('Not Found')
    err.status = 404
    next(err)

  # development error handler
  # will print stacktrace
  if (app.get('env') == 'development')
    app.use (err, req, res, next) ->
      console.log 'ERROR >>>', err
      # console.log 'STACK >>>', err.stack
      res.status(err.status || 500).send(err)

  # production error handler
  #  no stacktraces leaked to user
  app.use (err, req, res, next) ->
    console.error(err.stack)
    res.status(err.status || 500).send()
  app

module.exports = api
