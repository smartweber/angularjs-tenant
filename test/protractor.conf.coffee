exports.config = {
  baseUrl: 'http://localhost:9000/#'
  capabilities: {
    browserName: 'chrome'
  }
  frameworks: [ 'jasmine', 'jasmine-matchers' ]
  specs: [ './scenarios/*.{js,coffee}' ]
}
