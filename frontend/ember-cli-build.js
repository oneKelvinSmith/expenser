/* jshint node:true */
/* eslint no-var: 0 */
/* global require, module */

var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  var app = new EmberApp(defaults, {
    hinting: false,

    'ember-cli-qunit': {
      useLintTree: false
    }
  });

  app.import(app.bowerDirectory + '/bootstrap/dist/js/bootstrap.min.js');

  return app.toTree();
};
