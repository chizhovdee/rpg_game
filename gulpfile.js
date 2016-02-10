require('coffee-script/register');
require("./app/server/lib/lodash_mixin").register();

var requireDir = require('require-dir');
requireDir('./tasks', { recurse: true });

