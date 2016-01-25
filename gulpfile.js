require('coffee-script/register');
require("./server/lib/lodash_mixin").register();

var requireDir = require('require-dir');
requireDir('./tasks', { recurse: true });

