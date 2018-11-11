import { decode, encode } from 'base-64';

// Inject node globals into React Native global scope.
global.Buffer = require('buffer').Buffer;
global.process = require('process');

global.process.env.NODE_ENV = __DEV__ ? 'development' : 'production';
global.process.versions = { node: 'null', v8: 'null' };

// Needed so that 'stream-http' chooses the right default protocol.
global.location = {
  protocol: 'file:',
};

if (!global.btoa) {
  global.btoa = encode;
}

if (!global.atob) {
  global.atob = decode;
}
