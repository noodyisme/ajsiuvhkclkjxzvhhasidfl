@smart_stepup_v2.0_tag
Feature: Smart Stepup V-2.0 integration tests

 ########################### defining requests and responses
  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/smart_stepup_v2/smart_stepup_v2_payload.yml')
    * def responses = read('classpath:config/data/responses/smart_stepup_v2/smart_stepup_v2_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=smart_stepup&policyVersion=2.0'

  @smart_stepup_v2.0_tag1
  Scenario: Validating Success scenario for Smart stepup v2.0 with mandatory fields
    * call wfResponse { payload: '#(payloads.smart_stepup_v2_request)', httpStatus: 200 }

  @smart_stepup_v2.0_tag2
  Scenario: Validating Success scenario for Smart stepup v2.0 With allow from the Risk domain.
    Given url URL
    And request payloads.smart_stepup_v2_request
    When method post
    Then match responseStatus == 200
    * print 'Received response from the policy:', response
    Then match response.policyResponseBody.riskAssessmentStatus == 'ALLOW'

  @smart_stepup_v2.0_tag3
  Scenario: Validating Success scenario for Smart stepup v2.0 With challenge from the Risk domain.
    Given url URL
    And request payloads.smart_stepup_v2_request_challenge
    When method post
    Then match responseStatus == 200
    * print 'Received response from the policy:', response
    Then match response.policyResponseBody.result.head.result == 'CHALLENGE'

  @smart_stepup_v2.0_tag4
  Scenario: Validating failure scenario for Smart stepup v2.0 without sending mandatory fields.
    Given url URL
    And request payloads.smart_stepup_v2_request_missing_fields
    When method post
    Then match responseStatus == 200
    Then match response.errorInformation.id == '0'
    And match response.policyStatus == 'INVALID'

  @smart_stepup_v2.0_tag5
  Scenario: Validating failure scenario for Smart stepup v2.0 without Authorization headers for 403
    * set req_headers.Api-Key = 'SYSTEM'
    * set req_headers.Accept = 'application/json;v=1'
    * configure headers = req_headers
    * def responseJson = responses.ecommerce_http_403_resp
    Given url URL
    And request payloads.smart_stepup_v2_request
    When method post
    Then match responseStatus == 403
    Then match response == responseJson

  @smart_stepup_v2.0_tag6
  Scenario: Validating failure scenario for Smart stepup v2.0 without Authorization headers for 404
    * def responseJson = responses.policy_definitions_error_resp
    Given url URL + '/sample/test'
    And request payloads.smart_stepup_v2_request
    When method post
    Then match responseStatus == 404
    Then match response == responseJson

  @smart_stepup_v2.0_tag6
  Scenario: Validating failure scenario for Smart stepup v2.0 without Authorization headers for 406
    * set req_headers.Api-Key = 'MOBILE'
    * set req_headers.Accept = 'application/json;v=1'
    * configure headers = req_headers
    * def responseJson = responses.continue_policy_process_406_error_resp
    Given url URL
    And request payloads.smart_stepup_v2_request
    When method post
    Then match responseStatus == 406
    Then match response == responseJson

  @smart_stepup_v2.0_tag7
  Scenario: Triggering step 2 of the smart step up v2.0 for success
#   Call step 1 for risk domain
    Given url URL
    And request payloads.smart_stepup_v2_request_challenge
    When method post
    Then match responseStatus == 200
    * def policyProcessId = response.metadata.policyProcessId
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
    * def CONTINUEURL = baseURL + 'policy-processes/' + policyProcessId + '/continue-process' + "?step=step2"
#   Call step 2 for initiating the challenge method
    Given url CONTINUEURL
    And request payloads.smart_stepup_v2_step2_request
    When method post
    Then match responseStatus == 200
    And match response.policyStatus == 'SUCCESS'
    And match response.metadata.stepsCompleted == [ "start", "step2" ]
    * print 'Step 2 response ' , response.policyResponseBody
    * print 'step 2 expected response ' , responses.smart_stepup_v2_step2_response
    And match response.policyResponseBody == responses.smart_stepup_v2_step2_response

  @smart_stepup_v2.0_tag8
  Scenario: Triggering step 2 of the smart step up v2.0 for success without providing step parameter
#   Call step 1 for risk domain
    Given url URL
    And request payloads.smart_stepup_v2_request_challenge
    When method post
    Then match responseStatus == 200
    * def policyProcessId = response.metadata.policyProcessId
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
    * def CONTINUEURL = baseURL + 'policy-processes/' + policyProcessId + '/continue-process'
#   Call step 2 for initiating the challenge method
    Given url CONTINUEURL
    And request payloads.smart_stepup_v2_step2_request
    When method post
    Then match responseStatus == 400

  @smart_stepup_v2.0_tag9
  Scenario: Triggering step 2 and 3  of the smart step up v2.0 for success
#   Call step 1 for risk domain
    Given url URL
    And request payloads.smart_stepup_v2_request_challenge
    When method post
    Then match responseStatus == 200
    * def policyProcessId = response.metadata.policyProcessId
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
    * def CONTINUEURL = baseURL + 'policy-processes/' + policyProcessId + '/continue-process' + "?step=step2"
#   Call step 2 for initiating the challenge method
    Given url CONTINUEURL
    And request payloads.smart_stepup_v2_step2_request
    When method post
    Then match responseStatus == 200
    And match response.policyStatus == 'SUCCESS'
    And match response.metadata.stepsCompleted == [ "start", "step2" ]
    * print 'Step 2 response ' , response.policyResponseBody
    * print 'step 2 expected response ' , responses.smart_stepup_v2_step2_response
    And match response.policyResponseBody == responses.smart_stepup_v2_step2_response
#  CaLL step 3 for validating the challenge method
    * def responseJson = responses.smart_stepup_v2_step3_response
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
    * def CONTINUEURL = baseURL + 'policy-processes/' + policyProcessId + '/continue-process' + "?step=step3"
    Given url CONTINUEURL
    And request payloads.smart_stepup_v2_step3_request
    When method post
    Then match responseStatus == 200
    And match response.policyStatus == 'SUCCESS'
    And match response == responseJson

  @smart_stepup_v2.0_tag10
  Scenario: Triggering step 2 and 3  of the smart step up v2.0 for failure with invalid step
#   Call step 1 for risk domain
    Given url URL
    And request payloads.smart_stepup_v2_request_challenge
    When method post
    Then match responseStatus == 200
    * def policyProcessId = response.metadata.policyProcessId
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
    * def CONTINUEURL = baseURL + 'policy-processes/' + policyProcessId + '/continue-process' + "?step=step3"
#   Call step 2 for initiating the challenge method
    Given url CONTINUEURL
    And request payloads.smart_stepup_v2_step2_request
    When method post
    Then match responseStatus == 200
    And match response.policyStatus == 'INVALID'

  @smart_stepup_v2.0_tag11
  Scenario: Triggering step 2 of the smart step up v2.0 for failure with missing mandatory fields on step 2
#   Call step 1 for risk domain
    Given url URL
    And request payloads.smart_stepup_v2_request_challenge
    When method post
    Then match responseStatus == 200
    * def policyProcessId = response.metadata.policyProcessId
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
    * def CONTINUEURL = baseURL + 'policy-processes/' + policyProcessId + '/continue-process' + "?step=step3"
#   Call step 2 for initiating the challenge method
    Given url CONTINUEURL
    And request payloads.smart_stepup_v2_step2_request_missing_fields
    When method post
    Then match responseStatus == 200
    And match response.policyStatus == 'INVALID'
    Then match response.errorInformation.id == '0'

  @smart_stepup_v2.0_tag12
  Scenario: Triggering step 2 and 3  of the smart step up v2.0 for failure without mandatory fields
#   Call step 1 for risk domain
    Given url URL
    And request payloads.smart_stepup_v2_request_challenge
    When method post
    Then match responseStatus == 200
    * def policyProcessId = response.metadata.policyProcessId
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
    * def CONTINUEURL = baseURL + 'policy-processes/' + policyProcessId + '/continue-process' + "?step=step2"
#   Call step 2 for initiating the challenge method
    Given url CONTINUEURL
    And request payloads.smart_stepup_v2_step2_request
    When method post
    Then match responseStatus == 200
    And match response.policyStatus == 'SUCCESS'
    And match response.metadata.stepsCompleted == [ "start", "step2" ]
    * print 'Step 2 response ' , response.policyResponseBody
    * print 'step 2 expected response ' , responses.smart_stepup_v2_step2_response
    And match response.policyResponseBody == responses.smart_stepup_v2_step2_response
#  CaLL step 3 for validating the challenge method
    * def responseJson = responses.smart_stepup_v2_step3_response
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
    * def CONTINUEURL = baseURL + 'policy-processes/' + policyProcessId + '/continue-process' + "?step=step3"
    Given url CONTINUEURL
    And request payloads.smart_stepup_v2_step3_request_missing_fields
    When method post
    Then match responseStatus == 200
    And match response.policyStatus == 'INVALID'
    Then match response.errorInformation.id == '0'