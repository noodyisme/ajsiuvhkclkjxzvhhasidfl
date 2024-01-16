@behaviour_sec_1.0_tag
Feature: Behaviour Sec 1.0 Integration Tests

  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/behaviour_sec/behaviour_sec_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/behaviour_sec/behaviour_sec_1.0_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=behaviosec_risk&policyVersion=1.0'
    * copy reqHeadersCopy = req_headers

  @behaviour_sec_1.0_tag1
  Scenario: Validating Profile Referece Id as Empty for Behaviour Sec 1.0 with mandatory fields
    * call wfResponse { payload: '#(payloads.behaviour_sec_empty_profile_referece_id_successfull_req)', response: '#(responses.behaviour_sec_empty_Profile_Reference_Id_resp)', httpStatus: 200 }

  @behaviour_sec_1.0_tag2
  Scenario: Validating VendorSolution as Empty for Behaviour Sec 1.0 with mandatory fields
    * call wfResponse { payload: '#(payloads.behaviour_sec_empty_vendorSolution_successfull_req)', response: '#(responses.behaviour_sec_empty_vendorSolution_resp)', httpStatus: 200 }

  @behaviour_sec_1.0_tag3
  Scenario: Validating VendorSolution as Invalid value for Behaviour Sec 1.0 with mandatory fields
    * call wfResponse { payload: '#(payloads.behaviour_sec_invalid_vendorSolution_successfull_req)', response: '#(responses.behaviour_sec_empty_vendorSolution_resp)', httpStatus: 200 }

  @behaviour_sec_1.0_tag4
  Scenario: Validating vendorApiAction as Empty value for Behaviour Sec 1.0 with mandatory fields
    * call wfResponse { payload: '#(payloads.behaviour_sec_empty_vendorApiAction_successfull_req)', response: '#(responses.behaviour_sec_empty_vendorApiAction_resp)', httpStatus: 200 }

  @behaviour_sec_1.0_tag5
  Scenario: Validating vendorApiAction as Invalid value for Behaviour Sec 1.0 with mandatory fields
    * call wfResponse { payload: '#(payloads.behaviour_sec_invalid_vendorApiAction_successfull_req)', response: '#(responses.behaviour_sec_empty_vendorApiAction_resp)', httpStatus: 200 }

  @behaviour_sec_1.0_tag6
  Scenario: Validating Success scenario for Behaviour Sec 1.0 with Missed vendorSolution mandatory fields
    * call wfResponse { payload: '#(payloads.behaviour_sec_missed_vendorSolution_req)', response: '#(responses.behaviour_sec_missed_vendorSolution_error_resp)', httpStatus: 200 }

  @behaviour_sec_1.0_tag7
  Scenario: Validating Success scenario for Behaviour Sec 1.0 with Missed Profile Reference Id mandatory fields
    * call wfResponse { payload: '#(payloads.behaviour_sec_missed_profile_reference_id_req)', response: '#(responses.behaviour_sec_missed_profile_reference_id_resp)', httpStatus: 200 }

  @behaviour_sec_1.0_tag8
  Scenario: Validating Success scenario for Behaviour Sec 1.0 with Missed VendorApiAction mandatory fields
    * call wfResponse { payload: '#(payloads.behaviour_sec_missed_vendorApiAction_req)', response: '#(responses.behaviour_sec_missed_vendorApiAction_resp)', httpStatus: 200 }

  @behaviour_sec_1.0_tag9
  Scenario: Validating Success scenario for Behaviour Sec 1.0 with Missed Client Correlation Id mandatory fields
    * call wfResponse { payload: '#(payloads.behaviour_sec_missed_client_correlation_id_req)', response: '#(responses.behaviour_sec_missed_client_correlation_id_resp)', httpStatus: 200 }

  @behaviour_sec_1.0_tag10
  Scenario: Validating Success scenario for Behaviour Sec 1.0 with Missed CustomerBehaviorInsightId mandatory fields
    * call wfResponse { payload: '#(payloads.behaviour_sec_missed_customerBehaviorInsightId_req)', response: '#(responses.behaviour_sec_missed_customerBehaviorInsightId_resp)', httpStatus: 200 }

  @behaviour_sec_1.0_tag11
  Scenario: Validating HTTP 403 Status code for Behaviour Sec 1.0 with mandatory fields
    * set reqHeadersCopy.Api-Key = 'SYSTEM'
    * configure headers = reqHeadersCopy
    * print 'Calling Behaviour Sec validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.behaviour_sec_403_error_code_resp
    * print 'responsejson:', responsejson
    Given url URL
    When method get
    Then match responseStatus == 403
    * print 'Interactive Behaviour Sec API (first endpoint) response:', response
    Then match response == responsejson

  @behaviour_sec_1.0_tag12
  Scenario: Validating HTTP 405 Status code for Behaviour Sec 1.0 with mandatory fields
    * def responsejson = responses.behaviour_sec_405_error_code_resp
    Given url URL
    When method get
    Then match responseStatus == 405
    * print 'Interactive get Behaviour sec API (first endpoint) response:', response
    Then match response == responsejson

  @behaviour_sec_1.0_tag13
  Scenario: Validating HTTP 406 Status code for Behaviour Sec 1.0 with mandatory fields
    * set reqHeadersCopy.Api-Key = 'MOBILE'
    * set reqHeadersCopy.Accept = 'application/xml;v=1'
    * configure headers = reqHeadersCopy
    * print 'GET headers is:', headers
    * print 'Calling initiate Behaviour sec validation API (second URL)'
    * def responsejson = responses.behaviour_sec_406_error_code_resp
    * print 'responsejson:', responsejson
    Given url URL
    And request payloads.behaviour_sec_successfull_req
    When method POST
    Then match responseStatus == 406
    * print 'Interactive get Behaviour sec API (first endpoint) response:', response
    Then match response == responsejson

  @behaviour_sec_1.0_tag14
  Scenario: Validating HTTP 404 Status code for Behaviour Sec 1.0 with mandatory fields
    * def URL = URL + '?policyName=behaviour_sec&policyVersion=0.5'
    * def responsejson = responses.behaviour_sec_404_error_code_resp
    Given url URL
    And request payloads.behaviour_sec_successfull_req
    When method POST
    Then match responseStatus == 404
    * print 'Interactive get Behaviour sec API (first endpoint) response:', response
    Then match response == responsejson