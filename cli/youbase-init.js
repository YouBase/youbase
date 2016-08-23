#! /usr/bin/env node

var fs = require('fs');
var url = require('url');
var path = require('path');
var cli = require('commander');

var list = function (val) {
  return val.split(',');
}

cli
  .usage('[options]')
  .option('-C, --chdir <path>', 'change the working directory')
  .option('-c, --config <path>', 'set config path. defaults to ./youbase.json', './youbase.json')
  .option('-h, --host [host]', 'api listens on [host]. defaults to localhost', 'localhost')
  .option('-p, --port [port]', 'api listens on [port]. defaults to 9090', 9090)
  .parse(process.argv)

if (cli.chdir) { process.chdir(cli.chdir); }

var configPath = path.join(process.cwd(), cli.config)

var config = {
  host: cli.host,
  port: cli.port,
  url: (cli.url || url.format({protocol: 'http', hostname: cli.host, port: cli.port}))
}

fs.writeFile(configPath, JSON.stringify(config, null, '  '), function(err) {
  if (err) { return console.log(err); }
  console.log(cli.config + " has been created!");
});
