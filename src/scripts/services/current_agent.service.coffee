'use strict'
App.service 'currentAgent', [
  ->
    agent            = this
    agent.name       = 'Letting Agent name'
    agent.logoUrl    = ''
    agent.stylesheet = ''
    agent.loadCustomizations = (agentObj) ->
      agent.name       = agentObj.name
      agent.logoUrl    = agentObj.logoUrl
      agent.stylesheet = agentObj.stylesheet
    agent
]
