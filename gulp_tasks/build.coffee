module.exports = (gulp, plugins, config) ->
  gulp.task 'build:fonts', ->
    gulp.src config.paths.fonts.src
      .pipe gulp.dest config.paths.fonts.dest

  gulp.task 'build:styles:vendor', ->
    gulp.src plugins.mainBowerFiles()
      .pipe plugins.plumber()
      .pipe plugins.filter('**/*.less')
      .pipe plugins.less()
      .pipe plugins.concat config.paths.styles.vendor.name
      .pipe plugins.if config.env.production, plugins.cleanCss()
      .pipe plugins.if config.env.production, plugins.gzip()
      .pipe gulp.dest config.paths.styles.dest

  gulp.task 'build:styles:app', ->
    gulp.src config.paths.styles.main
      .pipe plugins.plumber()
      .pipe plugins.sass()
      .pipe plugins.concat config.paths.styles.name
      .pipe plugins.autoprefixer config.autoprefixer
      .pipe plugins.if config.env.production, plugins.cleanCss()
      .pipe plugins.if config.env.production, plugins.gzip()
      .pipe gulp.dest config.paths.styles.dest

  gulp.task 'build:styles:bower', ->
    gulp.src config.paths.styles.vendor.src
      .pipe plugins.plumber()
      .pipe plugins.sass()
      .pipe plugins.concat config.paths.styles.vendor.name
      .pipe plugins.autoprefixer config.autoprefixer
      .pipe plugins.if config.env.production, plugins.cleanCss()
      .pipe plugins.if config.env.production, plugins.gzip()
      .pipe gulp.dest config.paths.styles.dest

  gulp.task 'build:styles', (cb) ->
    plugins.runSequence([
      'build:styles:vendor',
      'build:styles:app',
      'build:styles:bower'
    ], cb)

  gulp.task 'build:scripts:vendor', ->
    gulp.src plugins.mainBowerFiles()
      .pipe plugins.plumber()
      .pipe plugins.filter('**/*.js')
      .pipe plugins.addSrc.append(config.paths.scripts.vendor.src)
      .pipe plugins.concat config.paths.scripts.vendor.name
      .pipe plugins.if config.env.production, plugins.uglify()
      .pipe plugins.if config.env.production, plugins.gzip()
      .pipe gulp.dest config.paths.scripts.dest

  gulp.task 'build:scripts:appConfig', ->
    env = if config.env.production then 'production' else 'development'
    envConfig = require('../src/config.json')[env]
    plugins.ngConstant {
      name: 'appConfig'
      constants: envConfig
      merge: true,
      stream: true
    }
    .pipe plugins.rename 'config.js'
    .pipe plugins.if config.env.production, plugins.uglify()
    .pipe gulp.dest config.paths.scripts.dest

  gulp.task 'build:scripts:app', ->
    gulp.src config.paths.scripts.src
      .pipe plugins.plumber()
      .pipe plugins.coffee()
      .pipe plugins.concat config.paths.scripts.name
      .pipe plugins.if config.env.production, plugins.uglify()
      .pipe plugins.if config.env.production, plugins.gzip()
      .pipe gulp.dest config.paths.scripts.dest

  gulp.task 'build:scripts', (cb) ->
    plugins.runSequence([
      'build:scripts:vendor',
      'build:scripts:appConfig',
      'build:scripts:app'
    ], cb)

  gulp.task 'build:templates:app', ->
    gulp.src config.paths.templates.src
      .pipe plugins.plumber()
      .pipe plugins.rubyHaml()
      .pipe plugins.angularTemplatecache config.templateCache
      .pipe gulp.dest config.paths.templates.dest

  gulp.task 'build:template:index', ->
    gulp.src config.paths.templates.index
      .pipe plugins.plumber()
      .pipe plugins.rubyHaml()
      .pipe gulp.dest config.paths.dest

  gulp.task 'build:templates', (cb) ->
    plugins.runSequence([
      'build:template:index',
      'build:templates:app',
    ], cb)

  gulp.task 'build:icons', ->
    gulp.src config.paths.icons.src
      .pipe plugins.svgSprites config.svgSprites
      .pipe gulp.dest config.paths.icons.dest

  gulp.task 'build:images', ->
    gulp.src config.paths.images.src
      .pipe gulp.dest config.paths.images.dest

  gulp.task 'build:clean', ->
    gulp.src config.paths.dest, {read: false}
      .pipe plugins.clean()

  gulp.task 'build', ['build:clean'], (cb) ->
    plugins.runSequence([
      'build:templates'
      'build:fonts'
      'build:styles'
      'build:icons'
      'build:images'
      'build:scripts'
    ], cb)
