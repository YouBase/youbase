HDKey = require 'hdkey'

Document = require './document'
Custodian = require './custodian'
Collection = require './collection'

PURPOSE_CODE = 1337

bip39 = require('bip39')
coininfo = require('coininfo')

class Wallet
  constructor: (@custodian, @mnemonic=bip39.generateMnemonic(), @config={}) ->
    throw Error('invalid Mnemonic') unless bip39.validateMnemonic(@mnemonic)

    @coin = @config.coin ? 'BTC'
    @versions = coininfo(@coin)?.versions

    @seed = bip39.mnemonicToSeed(@mnemonic)
    @rootkey = HDKey.fromMasterSeed(@seed, @versions.bip32)
    @hdkey = @rootkey.derive("m/#{PURPOSE_CODE}'")

    @privateExtendedKey = @hdkey.privateExtendedKey

    @profiles = new Collection(@custodian, Document, @privateExtendedKey, true)

Wallet.generateMnemonic = () ->
    bip39.generateMnemonic()

exports = module.exports = Wallet

