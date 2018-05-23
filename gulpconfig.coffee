util = require 'gulp-util'

isProduction = util.env.env is 'production'
dest         = if isProduction then 'dist' else 'build'
src          = './src'
nodeDir      = './node_modules'
bowerDir     = './bower_components'

config = {
  env: {
    production: isProduction
    test: util.env.env is 'test'
    development: util.env.env is 'development'
  }

  autoprefixer: {
    browsers: ['last 2 versions']
    cascade: false
  }

  loadPlugins: {
    pattern: [
      'gulp-*'
      'gulp.*'
      'run-sequence'
      'main-bower-files'
    ]
  }

  scssLint: {
    bundleExec: true
    config: '.scss-lint.yml'
  }

  hamlLint: {
    shellCommand: "bundle exec haml-lint -c .haml-lint.yml #{src}/templates/"
    shellOptions: {
      ignoreErrors: true
    }
  }

  templateCache: {
    module: 'appTemplates'
    standalone: true
  }

  coffeeLint: {
    optFile: 'coffeelint.json'
  }

  svgSprites: {
    cssFile: 'icons.css'
    baseSize: 14
    svg: {
      sprite: 'icons.svg'
    }
    preview: false
    svgPath: 'icons.svg'
    pngPath: 'icons.png'
  }

  test: {
    karma: 'test/karma.conf.coffee'
    protractor: 'test/protractor.conf.coffee'
  }

  paths: {
    dest: dest

    icons: {
      src: 'src/icons/*.svg'
      dest: dest + '/icons'
    }

    images: {
      src: 'src/images/**/*'
      dest: dest + '/images'
    }

    fonts: {
      src: [
        "#{src}/fonts/**/*"
      ]
      dest: "#{dest}/fonts"
    }

    scripts: {
      name: 'application.js'
      src: "#{src}/scripts/**/*.coffee"
      dest: "#{dest}/scripts"
      vendor: {
        name: 'vendor.js'
        src: [
          'node_modules/ng-infinite-scroll/build/ng-infinite-scroll.min.js'
        ]
      }
    }

    styles: {
      name: 'application.css'
      src: "#{src}/styles/**/*.scss"
      main: "#{src}/styles/main.scss"
      dest: "#{dest}/styles"
      vendor: {
        name: 'bower.css'
        src: [
          'bower_components/flexslider/flexslider.css'
        ]
      }
    }

    templates: {
      src: ["#{src}/templates/**/*.haml", '!src/templates/index.haml']
      dest: "#{dest}/scripts"
      index: 'src/templates/index.haml'
    }

    scenarios: {
      src: 'test/scenarios/*.coffee'
    }

    gulp: {
      src: [
        'gulpfile.coffee',
        '.gulp-config.coffee',
        'gulp_tasks/*.coffee'
      ]
    }
  }
}

module.exports = config
