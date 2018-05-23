module.exports = (gulp, plugins, config) ->
  gulp.task 'serve', ->
    gulp.src config.paths.dest
      .pipe plugins.webserver {
        livereload: true
        directoryListing: false
        open: false
        port: 9000
        fallback: 'index.html'
      }

  gulp.task 'serve-protractor', ->
    gulp.src config.paths.dest
      .pipe plugins.webserver {
        livereload: false
        directoryListing: false
        open: false
        port: 9000
        fallback: 'index.html'
      }
