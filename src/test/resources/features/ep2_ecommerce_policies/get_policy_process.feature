@ECommerce_2.0_tag
Feature: Get Policy Process 2.0 integration tests
 
 ########################### defining requests and responses
  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/ecommerce/get_policy_process_payload.yml')
    * def responses = read('classpath:config/data/responses/ecommerce/get_policy_process_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * def noWfResponse = read('classpath:features/utilities/one_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=ecommerce_step_up&policyVersion=2.0'
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
    * copy reqHeadersCopy = req_headers

     ###################### Positive Scenario #########################
  @get_policy_process_tag1
  Scenario: Validating Success scenario for Policy Process with mandatory fields
    * call wfResponse { payload: '#(payloads.ecommerce_successfull_req)', response: '#(responses.ecommerce_successfull_resp)', httpStatus: 200 }
    * def URL = baseURL + 'policy-processes/' + response.metadata.policyProcessId
    * print 'Calling get policy process validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.policy_process_successfull_resp
    * print 'responsejson:', responsejson
    Given url URL
    When method get
    Then match responseStatus == 200
    * print 'Interactive get policy process API (first endpoint) response:', response
    Then match response == responsejson

  @get_policy_process_tag2
  Scenario: Validating error scenario for Policy Process with mandatory fields
    * def URL = baseURL + 'policy-processes/7aa7db61-4c2b-4c6c-8b39-3329b6757501'
    * print 'Calling get policy process validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.policy_process_error_resp
    * print 'responsejson:', responsejson
    Given url URL
    When method get
    Then match responseStatus == 404
    * print 'Interactive get policy process API (first endpoint) response:', response
    Then match response == responsejson

  @get_policy_process_tag3
  Scenario: Validating 404 error scenario for Policy Process with mandatory fields
    * def URL = baseURL + 'policy-processes/'
    * print 'Calling get policy process validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.policy_process_404_error_resp
    * print 'responsejson:', responsejson
    Given url URL
    When method get
    Then match responseStatus == 404
    * print 'Interactive get policy process API (first endpoint) response:', response
    Then match response == responsejson

  @get_policy_process_tag4
  Scenario: Validating 403 error scenario for Policy Process with mandatory fields
    * call wfResponse { payload: '#(payloads.ecommerce_successfull_req)', response: '#(responses.ecommerce_successfull_resp)', httpStatus: 200 }
    * def URL = baseURL + 'policy-processes/'+response.metadata.policyProcessId
    * print 'Calling get policy process validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.policy_process_403_error_resp
    * print 'responsejson:', responsejson
    * set reqHeadersCopy.Api-Key = 'SYSTEM'
    * set reqHeadersCopy.Accept = 'application/json;v=1'
    * configure headers = reqHeadersCopy
    Given url URL
    When method get
    Then match responseStatus == 403
    * print 'Interactive get policy process API (first endpoint) response:', response
    Then match response == responsejson

  @get_policy_process_tag5
  Scenario: Validating 405 error scenario for Policy Process with mandatory fields
    * call wfResponse { payload: '#(payloads.ecommerce_successfull_req)', response: '#(responses.ecommerce_successfull_resp)', httpStatus: 200 }
    * def URL = baseURL + 'policy-processes/'+response.metadata.policyProcessId
    * print 'Calling get policy process validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.policy_process_405_error_resp
    * print 'responsejson:', responsejson
    Given url URL
    And request payloads.ecommerce_successfull_req
    When method POST
    Then match responseStatus == 405
    * print 'Interactive get policy process API (first endpoint) response:', response
    Then match response == responsejson

  @get_policy_process_tag6
  Scenario: Validating 406 error scenario for Policy Process with mandatory fields
    * call wfResponse { payload: '#(payloads.ecommerce_successfull_req)', response: '#(responses.ecommerce_successfull_resp)', httpStatus: 200 }
    * def URL = baseURL + 'policy-processes/'+response.metadata.policyProcessId
    * print 'Calling get policy process validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.policy_process_406_error_resp
    * print 'responsejson:', responsejson
    * set reqHeadersCopy.Api-Key = 'MOBILE'
    * set reqHeadersCopy.Accept = 'application/xml;v=1'
    * configure headers = reqHeadersCopy
    Given url URL
    When method get
    Then match responseStatus == 406
    * print 'Interactive get policy process API (first endpoint) response:', response
    Then match response == responsejson

