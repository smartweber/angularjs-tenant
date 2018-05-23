module.exports = (gulp, plugins, config) ->
  gulp.task 'watch', ->
    gulp.watch config.paths.styles.src, ['lint:styles', 'build:styles']
    gulp.watch config.paths.scripts.src, ['lint:scripts', 'build:scripts']
    gulp.watch config.paths.templates.src, ['lint:templates', 'build:templates']

  gulp.task 'watch:protractor', ->
    gulp.watch config.paths.styles.src, ['build:styles', 'run_protractor']
    gulp.watch config.paths.scripts.src, ['build:scripts', 'run_protractor']
    gulp.watch config.paths.templates.src, ['build:templates', 'run_protractor']
    gulp.watch config.paths.scenarios.src, ['build:templates', 'run_protractor']
