@ignore
Feature: Call Interactive Identity Verification API to Set verificationStatus to STARTED or PROCESSED and to Get t2vUUID Value

  Background:
    * def input = { verificationId: '#(verificationId)', t2vUuid: '#(t2vUuid)' }
    * def endpoint1 = 'https://api-it.cloud.capitalone.com/identity/interactive-verifications/' + input.verificationId + '/verify'
    * def endpoint2 = 'https://api-it.cloud.capitalone.com/identity/interactive-verifications/' + input.verificationId + '?fields=t2vUUID'
    * def endpoint3 = 'https://r2v-svc-ite.clouddqt.capitalone.com/r2v-svc/identity/interactive-verifications/redirect/' + input.t2vUuid + '?channel=mobile'
    # create copy of req_headers
    * copy reqHeadersCopy = req_headers
    # since the Accept header in req_headers in karate-config.js defaults to v=2, setting it to v=1 here for the APIs being called in this feature file
    * set reqHeadersCopy.Accept = 'application/json;v=1'
    # function for generating a Bearer token for the Authorization header if we don't already have it
    * def generateTokenAndSetAuthorizationHeader = 
        """
        function() {
          if (!reqHeadersCopy.Authorization || (reqHeadersCopy.Authorization.indexOf('Bearer') === -1)) {
            var result = karate.call('classpath:features/callOnce.feature')
            reqHeadersCopy.Authorization = 'Bearer ' + result.token
          }
        }
        """

  @interactive_identity_verification_tag1
  Scenario: Call Endpoint1 to Set verificationStatus to STARTED
    Given url endpoint1
    * generateTokenAndSetAuthorizationHeader()
    * configure headers = reqHeadersCopy
    * def jsonData = { phoneNumber: '1234567890', phoneType: 'MOBILE', optInMethod: 'OTHER' }
    And request jsonData
    * print 'Calling Interactive Identity Verification API (first endpoint)'
    * print 'POST url is:', endpoint1
    * print 'Body is:', jsonData
    * print 'Headers are:', reqHeadersCopy
    When method post
    * print 'Interactive Identity Verification API (first endpoint) response:', response
    Then match responseStatus == 201
    * def verificationStatus = response.verificationStatus

  @interactive_identity_verification_tag2
  Scenario: Call Endpoint2 to Get t2vUUID Value
    Given url endpoint2
    * generateTokenAndSetAuthorizationHeader()
    * configure headers = reqHeadersCopy
    * print 'Calling Interactive Identity Verification API (second endpoint)'
    * print 'GET url is:', endpoint2
    * print 'Headers are:', reqHeadersCopy
    When method get
    * print 'Interactive Identity Verification API (second endpoint) response:', response
    Then match responseStatus == 200
    * def t2vUuid = response.t2vUUID

  @interactive_identity_verification_tag3
  Scenario: Call Endpoint3 to Set verificationStatus to PROCESSED
    Given url endpoint3
    * configure headers = reqHeadersCopy
    And request {}
    * print 'Calling Interactive Identity Verification API (third endpoint)'
    * print 'POST url is:', endpoint3
    * print 'Headers are:', reqHeadersCopy
    When method post
    * print 'Interactive Identity Verification API (third endpoint) response:', response
    Then match responseStatus == 201
    * def verificationStatus = response.verificationStatus
