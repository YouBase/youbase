Getting Started
================

The Browser
-------

A ready to go minified version of the library is available in the [/dist][dist]
directory on [github][github] along with a sourcemap. Or you you can download it here.

> [Download >][download]

Once you have the youbase.min.js included in your project load it on your page
as you would any library.

``` html
<script src="/js/youbase.min.js"></script>
```

Once the script loads you will have access to YouBase exposed in the global scope.

``` javascript
var youbase = YouBase('http://localhost:9090');
```

NPM Install
-----------

To use YouBase with Node.js or browserify you can install it via NPM.

``` shell
> npm install -g youbase
```

Once installed you also have access to the command line tool.

``` shell
> youbase help
```

Custodians
----------

YouBase relies on custodians to provide storage to the network. Custodians can
use any storage method on the backend that supports key/value lookup.

### Local Custodian

Using the command line tool included in the npm package a custodian can
be run locally for development. By default the custodian will run on port 9090
and uses a in memory storage engine that does not persist to disk.

``` shell
> youbase api
```

### Connecting

Once your custodian is up and running it is time to connect. We do this using
the YouBase class that is available globally when the script is loaded in the
browser and is the default export of the NPM package.

``` javascript
var YouBase = require('youbase');
```

Once you have the YouBase class you can create a new instance by passing it the
url of the custodian.

``` javascript
var youbase = YouBase('http://localhost:9090');
```

Document Definition
-------------------

A Document Definition tells YouBase how the data in a document should be
structured, how it should be encrypted, and what to index.

### Permissions

YouBase has three levels of permissions that control how a document is
encrypted. The lowest level is **public** which leaves the data unencrypted.

``` json
"permissions": "public"
```

The second permission level is hardened. This encrypts the data using the
documents extended public key as the encryption key.

``` json
"permissions": "hardened"
```

Last we have private which encrypts the data using the documents private key as
the encryption key.

``` json
"permissions": "private"
```

### Meta

Meta describes which attributes should be available without
retrieving and decrypting the documents data. The meta information is pulled
from the document data and stored unencrypted. Since it is unencrypted it should
always be considered public.

``` json
"meta": {
  "height": "height",
  "weight": "weight"
}
```

The attributes can also be described using dot notation in order to pull data from
nested attributes.

``` json
"meta": {
  "height": "stats.height",
  "weight": "stats.weight"
}
```

### Form

Form gives hints on how a UI should create a form. It is based on
[schemaform.io](http://schemaform.io) and combined with the schema information
let's us automatically generate an interface for any document.

``` json
"form": ['*']
```

### Schema

[JSON Schema](http://json-schema.org/) is used to define the structure of a
document and validate it. This lets YouBase plug into existing schemas such as
[Open mHealth](http://www.openmhealth.org/documentation/#/schema-docs/schema-library)
with little change.

``` json
"schema": {
  "title": "Health Profile",
  "type": "object",
  "properties": {
    "height": {
      "title": "Height",
      "type": "number"
    },
    "weight": {
      "title": "Weight",
      "type": "number"
    }
  }
}
```

### Children

In YouBase a Document both stores data and has children documents allowing for
rich structured data. Every Definition includes a list of children definitions
along with a name that can be used when inserting children documents.

``` json
"children": {
  "allergy": {
    "permissions": "public",
    "meta": {},
    "form": ['*'],
    "schema": {
      "title": "Allergy",
      "type": "object",
      "properties": {
        "allergen": {
          "title": "Allergen",
          "type": "string"
        }
      },
      "required": ["allergen"]
    }
  }
}
```

Wallet
------

In the real world we store much more in our wallets than just money. We have
IDs, insurance cards, pictures, etc. In the same way YouBase lets you store
the personal data that you want to keep close in a digital wallet.

To use your digital wallet it must first be created.

``` javascript
var wallet = youbase.wallet();
```

When created a YouBase wallet generates a random 12 word mnemonic passphrase that is used
to generate all the rest of the keys in your wallet. If this passphrase is lost
you will lose all your data, so write it down.

```javascript
var passphrase = wallet.mnemonic;
```

Once you have your passphrase you can use it to recreate your wallet.

```javascript
var wallet = youbase.wallet(passphrase);
```

Collection
----------

A Collection is a group of Documents all under the same parent key. A wallet
starts out with a Collection called profiles.

```javascript
wallet.profiles;
```

Before you can add a document to a collection you must give it a definition describing the
document.

```javascript
var HealthProfile = require('youbase-health-profile-definition');
wallet.profiles.definition('health', HealthProfile);
```

With a definition in place we can now insert a document.

```javascript
var healthProfile = wallet.profiles.insert('health', {heightt: 72, weight: 200});
```

And get an array of all documents in a collection.

```javascript
wallet.profiles.all().then(function (profiles) { console.log(profiles; )});
```

Document
--------

Each document corresponds to a public key / private key pair in the wallet.
Unsing a document instance you can get the documents meta information as well as
pull the full document data..

``` javascript
healthProfile.meta().then(function (meta) { console.log(meta); });
healthProfile.data().then(function (data) { console.log(data); });
```

If you have the private key you will be able to update the record

``` javascript
healthProfile.data({height: 73, weight: 200});
healthProfile.save();
```

To make sure you have the recent version of a document fetch the document from
the custodian.

``` javascript
healthProfile.fetch();
```

When you have the extended key you can also access all the children documents
through a collection.

``` javascript
healthProfile.children.all();
```

Messages
--------

**(in-progress)**

[download]: https://raw.githubusercontent.com/YouBase/youbase/master/dist/youbase.min.js
[github]: https://github.com/YouBase/youbase
[dist]: https://github.com/YouBase/youbase/tree/master/dist
