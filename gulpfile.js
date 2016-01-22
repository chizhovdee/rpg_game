require('coffee-script/register');
require("./server/lib/lodash_mixin").setup();
require("./common/lodash_mixin").setup();

var requireDir = require('require-dir');
requireDir('./tasks', { recurse: true });

