'use strict'

describe 'App', ->
  beforeEach ->
    browser.get '/'

  it 'has a page title', ->
    expect(browser.getTitle()).toEqual('Property Technologies')

  it 'has a topbar', ->
    subject = element(By.css('.navbar.main'))

    brand = subject.element(By.css('.navbar-brand'))
    expect(brand.getText()).toMatch /Letting Agent/

    navbarLinks = subject.all(By.css('.navbar-right li'))
    expect(navbarLinks.getText()).toEqual [
      'Apply for a Property'
      'In-Progress Applications'
      'Contact Us'
    ]

  it 'has main container', ->
    subject = element(By.css('[ui-view]'))
    expect(subject.isPresent()).toBe true
