@ECommerce_2.0_tag
Feature: Get Policy Definitions 2.0 integration tests
 
 ########################### defining requests and responses
  Background:
    * configure headers = req_headers
    * def responses = read('classpath:config/data/responses/ecommerce/get_policy_definitions_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * def noWfResponse = read('classpath:features/utilities/one_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
    * def URL = baseURL + 'policy-definitions?policyName=ecommerce_step_up&policyVersion=2.0&step=four_confirm_challenge'
    * copy reqHeadersCopy = req_headers

     ###################### Positive Scenario #########################

  @get_policy_definitions_tag1
  Scenario: Validating Success scenario for Policy Definitions with mandatory fields
    * print 'Calling get policy definitions validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.policy_definitions_successfull_resp
    * print 'responsejson:', responsejson
    Given url URL
    When method get
    Then match responseStatus == 200
    * print 'Interactive get policy definitions API (first endpoint) response:', response
    Then match response == responsejson

  @get_policy_definitions_tag2
  Scenario: Validating error scenario for Policy Definitions with mandatory fields
    * def URL = baseURL + 'policy-definitions?policyName=ecommerce_step_up&policyVersion=1.0&step=four_confirm_challenge'
    * print 'Calling get policy definitions validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.policy_definitions_error_resp
    * print 'responsejson:', responsejson
    Given url URL
    When method get
    Then match responseStatus == 404
    * print 'Interactive get policy definitions API (first endpoint) response:', response
    Then match response == responsejson

  @get_policy_definitions_tag3
  Scenario: Validating http 404 error scenario for Policy Definitions with mandatory fields
    * def URL = baseURL + 'policy-definitions?policyName=ecommerce_step_up&policyVersion=1.0&four_confirm_challenge='
    * print 'Calling get policy definitions validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.policy_definitions_version_error_resp
    * print 'responsejson:', responsejson
    Given url URL
    When method get
    Then match responseStatus == 404
    * print 'Interactive get policy definitions API (first endpoint) response:', response
    Then match response == responsejson


  @get_policy_definitions_tag4
  Scenario: Validating http 403 error scenario for Policy Definitions with mandatory fields
    * set reqHeadersCopy.Api-Key = 'SYSTEM'
    * set reqHeadersCopy.Accept = 'application/json;v=1'
    * configure headers = reqHeadersCopy
    * print 'Calling get policy definitions validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.policy_definitions_403_error_resp
    * print 'responsejson:', responsejson
    Given url URL
    When method get
    Then match responseStatus == 403
    * print 'Interactive get policy definitions API (first endpoint) response:', response
    Then match response == responsejson

  @get_policy_definitions_tag5
  Scenario: Validating http 405 error scenario for Policy Definitions with mandatory fields
    * call wfResponse { payload: '', response: '#(responses.policy_definitions_405_error_resp)', httpStatus: 405 }
    * print 'Calling get policy definitions validation API (second URL)'
    * print 'GET url is:', URL
    * print 'Interactive get policy definitions API (first endpoint) response:', response

  @get_policy_definitions_tag6
  Scenario: Validating http 406 error scenario for Policy Definitions with mandatory fields
    * set reqHeadersCopy.Api-Key = 'MOBILE'
    * set reqHeadersCopy.Accept = 'application/xml;v=1'
    * configure headers = reqHeadersCopy
    * print 'Calling get policy definitions validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.policy_definitions_406_error_resp
    * print 'responsejson:', responsejson
    Given url URL
    When method get
    Then match responseStatus == 406
    * print 'Interactive get policy definitions API (first endpoint) response:', response
    Then match response == responsejson
