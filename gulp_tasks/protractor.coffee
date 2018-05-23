module.exports = (gulp, plugins, config) ->
  protractor = plugins.protractor.protractor

  gulp.task 'webdriver_update', protractor.webdriver_update
  gulp.task 'webdriver_standalone', protractor.webdriver_standalone

  gulp.task 'run_protractor', ->
    gulp.src ['test/scenarios/*.coffee']
    .pipe protractor {
      configFile: config.test.protractor
    }

  gulp.task 'protractor', ['webdriver_update'], (cb) ->
    plugins.runSequence 'build',
      'watch:protractor',
      'serve-protractor',
      'run_protractor'
