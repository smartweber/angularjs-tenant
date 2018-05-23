# Property Technology - Application Form

## Development Setup

You must have node.js (>= 4.0) and its package manager (npm) installed. 
You can get them from [http://nodejs.org/](http://nodejs.org/).
You also need Ruby and its package manager (bundler).

### Install Dependencies

* Get ruby dependencies via `bundler`, the [ruby package manager](http://bundler.io/).
* Get the tools we depend upon via `npm`, the [node package manager](https://www.npmjs.com/).
* Get the angular code via `bower`, a [client-side code package manager](https://bower.io/).

We have preconfigured `npm` to automatically run `bower` so we can simply do:

```
bundle install
npm install
```

Optionally install coffelint globally: `npm install -g coffeelint`

### Run the Application

The project uses [Gulp](http://gulpjs.com/) to start a development web server. Here are the available commands:

```
npm run build        # generates a development build under ./build       
npm run dist         # generates a production build under ./dist
npm run lint         # runs the configured linters against the codebase      
npm run protractor   # runs the E2E tests
npm run test         # runs the unit tests

npm start            # builds, watches for changes and boots a webserver
```

After doing `npm start` you can browse the app at `http://localhost:9000/`.
This command will build the app, watch for changes and automatically reload and run unit tests when a source file is changed.

## Directory Layout

```
src/                    --> all of the source files for the application
  scripts/              --> all app scripting
  styles/               --> all app stylesheets
  templates/            --> HTML partial templates
  fonts/                --> app fonts
bower_components        --> packages downloaded via Bower
node_modules            --> packages downloaded via npm
test/                   --> all app tests
  scenarios/            --> End-to-end test framework
  spec/                 --> Unit tests
Gemfile                 --> Bundler manifest file
bower.json              --> Bower manifest file
package.json            --> npm manifest file
gulpfile.coffee         --> gulp configuration
```

## Testing

The tests are all written in [Jasmine][jasmine]. 

* the configuration is found at `test/jasmine.conf.coffee`
* the end-to-end tests are found in `test/spec/*.coffee`

The easiest way to run the unit tests is to use the supplied grunt script:

```
npm run test
```

This script will start the Karma test runner to execute a single run of the tests.


### End to End Testing

These tests are run with the [Protractor][protractor] End-to-End test runner.  It uses native events and has special features for Angular applications.

* the configuration is found at `test/protractor.conf.coffee`
* the end-to-end tests are found in `test/scenarios/*.coffee`

Protractor simulates interaction with our web app and verifies that the application responds correctly.
Therefore, our web server needs to be serving up the application, so that Protractor can interact with it.

```
npm run protractor
```

This script will execute the end-to-end tests against the application being hosted on the development server, but note that you need to kill the server (ctrl+c) after tests are run.


## Building and Deployment

Run `npm run dist` and the production ready application source will the under the `dist` directory. Simply deploy it to a static webserver.
