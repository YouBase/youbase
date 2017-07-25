express = require 'express'

api = (app, config) ->

  dbconfig = storage: 'levelup', dblocation: config.dblocation, cleardb: config.cleardb
  routes = require('./routes')( require('../custodian')(dbconfig))
  app.use require('morgan')('dev')

  app.use (req, res, next) ->
    data=''
    req.setEncoding('utf8')
    req.on 'data', (chunk) -> data += chunk
    req.on 'end', ->
      if req.headers['content-type'] == 'application/json' && !!(data?.length)
        req.body = JSON.parse(data)
      else req.body = data
      next()

  app.use (req, res, next) ->
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Auth")
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
