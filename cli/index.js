#! /usr/bin/env node

var cli = require('commander');
var version = require('../package.json').version

cli
  .version(version)
  .command('api [options]', 'start the api with a specific config')
  .command('init [options]', 'create a config file')
  .parse(process.argv);
