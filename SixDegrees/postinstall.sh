#!bin/bash

# fix fetch-npm-browserify.js undefined self
sed -i '' '5i\
//' node_modules/isomorphic-fetch/fetch-npm-browserify.js

sed -i '' '6i\
var globalObj = this.self || this; module.exports = globalObj.fetch.bind(globalObj); //' node_modules/isomorphic-fetch/fetch-npm-browserify.js

# fix fetch-npm-browserify.js undefined self
# sed -i '' '7i\
# var {randomBytes} = require("randombytes"); //' node_modules/eosjs-ecc/lib/key_utils.js
