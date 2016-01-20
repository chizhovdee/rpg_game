require('coffee-script/register');

var requireDir = require('require-dir');
requireDir('./tasks', { recurse: true });

