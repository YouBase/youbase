#! /usr/bin/env node
require('dotenv').config({silent: true});

var _ = require('lodash');

var fs = require('fs');
var path = require('path');
var cli = require('commander');
var express = require('express');

var api = require('../lib/api');

cli
  .usage('[options]')
  .option('-C, --chdir <path>', 'change the working directory')
  .option('-c, --config <path>', 'set config path. defaults to ./youbase.json', './youbase.json')
  .option('-h, --host [host]', 'api listens on [host]. defaults to localhost', 'localhost')
  .option('-p, --port [port]', 'api listens on [port]')
  .option('-l, --dblocation <dblocation>', 'api stores data at <dblocation>')
  .option('-X, --cleardb [cleardb]', 'api clears db on start', false)
  .parse(process.argv)

if (cli.chdir) { process.chdir(cli.chdir); }

configPath = path.join(process.cwd(), cli.config);

var config = {
  host: process.env.YOUBASE_HOST,
  port: (process.env.YOUBASE_PORT || process.env.PORT)
};

fs.access(configPath, fs.F_OK, function(err) {
  if (!err) { _.defaults(config, require(configPath)); }

  var port = cli.port || config.port || 9090
  var host = cli.host || config.host || 'localhost'
  config.dblocation = cli.dblocation || config.dblocation
  config.cleardb = cli.cleardb

  var app = express()

  var server = app.listen(port, function () {
    console.log('YouBase api listening at http://%s:%s', host, port)
  });

  api(app, config);
});




