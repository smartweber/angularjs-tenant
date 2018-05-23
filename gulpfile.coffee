fs      = require 'fs'
gulp    = require 'gulp'
config  = require './gulpconfig.coffee'
plugins = require('gulp-load-plugins')(config.loadPlugins)

fs.readdirSync('gulp_tasks').forEach (file) ->
  return unless file.match(/.+\.coffee/g)?
  require('./gulp_tasks/' + file)(gulp, plugins, config)

gulp.task 'default', ->
  plugins.runSequence 'build', 'watch', 'karmaServer', 'serve'
