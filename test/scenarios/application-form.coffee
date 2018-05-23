'use strict'

describe 'Application Form', ->
  subject = element(By.css('[ui-view] .main-application-form'))

  beforeEach ->
    browser.get '/'

  it 'has a natural language form', ->
    expect(subject.getText()).toMatch /Hi, my name is/
