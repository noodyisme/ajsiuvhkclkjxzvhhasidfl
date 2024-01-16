@ignore
Feature: Call DCRP-OL With Given policyProcessId

  Background:
    * def input = { policyProcessId: '#(policyProcessId)' }
    * def endpoint = 'https://verified-it.capitalone.com/dcrp-ol-web/orch/execute?platformVersion=2'
    # create copy of req_headers
    * copy reqHeadersCopy = req_headers
    # since the Accept header in req_headers in karate-config.js defaults to v=2, setting it to v=1 here for the DCRP-OL call in this feature file
    * set reqHeadersCopy.Accept = 'application/json;v=1'
    * configure headers = reqHeadersCopy
    * configure proxy = 'http://ashproxy.kdc.capitalone.com:8099'

  Scenario: Call DCRP-OL Endpoint With Given policyProcessId
    Given url endpoint
    * def jsonData = { policyProcessId: '#(input.policyProcessId)' }
    And request jsonData
    * print 'Calling DCRP-OL'
    * print 'POST url is:', endpoint
    * print 'Body is:', jsonData
    * print 'Headers are:', reqHeadersCopy
    When method post
    * print 'DCRP-OL response:', response
    Then match responseStatus == 200
    * def setCookieResponseHeader = responseHeaders['Set-Cookie']
