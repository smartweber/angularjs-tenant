'use strict'

ibrik = require 'ibrik'

module.exports = (config) ->

  config.set {
    basePath: '../'

    frameworks: [ 'jasmine', 'jasmine-matchers' ]

    preprocessors: {
      'src/scripts/**/*.coffee': ['coverage']
      'test/spec/**/*.coffee': ['coffee']
    }

    files: [
      'bower_components/jquery/dist/jquery.js'
      'bower_components/angular/angular.js'
      'bower_components/angular-animate/angular-animate.js'
      'bower_components/angular-cookie/angular-cookie.js'
      'bower_components/angular-mocks/angular-mocks.js'
      'bower_components/angular-perfect-scrollbar/src/\
          angular-perfect-scrollbar.js'
      'bower_components/angular-ui-router/release/angular-ui-router.js'
      'bower_components/lodash/dist/lodash.min.js'
      'bower_components/ng-dialog/js/ngDialog.js'
      'bower_components/ng-token-auth/dist/ng-token-auth.min.js'
      'bower_components/pluralize/pluralize.js'
      'bower_components/angular-fallback-image/dist/angular-fallback-image.js'
      'bower_components/ngmap/build/scripts/ng-map.min.js'

      'node_modules/ng-infinite-scroll/build/ng-infinite-scroll.min.js'

      'build/scripts/templates.js'
      'src/scripts/**/*.coffee'
      'test/spec/app_config.coffee'
      'test/spec/helpers.coffee'
      'test/spec/**/*_test.coffee'
    ]

    coffeePreprocessor: {
      options: {
        bare: true
        sourceMap: false
      }
    }

    coffeeCoverage: {
      preprocessor: {
        instrumentor: 'istanbul'
      }
    }

    coverageReporter: {
      type: 'html'
      instrumenters: {
        ibrik: ibrik
      }
      instrumenter: {
        '**/*.coffee': 'ibrik'
      }
    }

    reporters: ['progress', 'coverage']

    browsers: [
      # 'Chrome'
      'PhantomJS'
    ]

    singleRun: true

    exclude: []

    autoWatch: true

    colors: true

    logLevel: config.LOG_INFO
  }
