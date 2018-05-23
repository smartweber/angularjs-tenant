module.exports = (gulp, plugins, config) ->
  gulp.task 'lint:styles', ->
    gulp.src config.paths.styles.src
      .pipe plugins.plumber()
      .pipe plugins.scssLint(config.scssLint)

  gulp.task 'lint:scripts', ->
    gulp.src config.paths.scripts.src
      .pipe plugins.coffeelint()
      .pipe plugins.coffeelint.reporter()

  gulp.task 'lint:templates', plugins.shell.task(
    config.hamlLint.shellCommand,
    config.hamlLint.shellOptions
  )

  gulp.task 'lint:self', ->
    gulp.src config.paths.gulp.src
      .pipe plugins.coffeelint()
      .pipe plugins.coffeelint.reporter()

  gulp.task 'lint', ->
    plugins.runSequence(
      [
        'lint:self'
        'lint:styles',
        'lint:scripts',
        'lint:templates'
      ]
    )
