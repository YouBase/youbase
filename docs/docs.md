Getting Started
================

Install Youbase
---------------

### Node.js

``` shell
npm install -g youbase
```

### Browser

``` html
<script src="/js/youbase.min.js"></script>
```

### Source

``` shell
git clone git@github.com:YouBase/youbase.git
cd youbase
npm install
npm link
```

Run A Custodian
---------------

``` shell
youbase api
```

Read & Write Data
-----------------

### Youbase

``` javascript
var youbase = Youbase('http://localhost:9090');
```

### Wallet

``` javascript
// View the passphrase for your new wallet
var wallet = youbase.wallet();

// View the passphrase for your new wallet
var passphrase = wallet.mnemonic;

// Use the passphrase to restore a wallet
var wallet = youbase.wallet(passphrase);
```

### Definition

### Document

Send & Recieve Messages
-----------------------
