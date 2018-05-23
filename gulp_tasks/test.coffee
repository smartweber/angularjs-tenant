module.exports = (gulp, plugins, config) ->
  Server = require('karma').Server
  path = require 'path'

  gulp.task 'karmaServer', ->
    new Server({
      configFile: path.resolve(__dirname, '../', config.test.karma)
      singleRun: not config.env.development
    }).start()

  gulp.task 'test', ->
    plugins.runSequence('build:templates', 'karmaServer')
