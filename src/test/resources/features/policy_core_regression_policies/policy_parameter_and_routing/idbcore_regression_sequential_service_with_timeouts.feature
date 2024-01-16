@idbcore_regression_sequential_service_with_timeouts_1.0_tag
Feature: IDB Core Sequential Downstream APIs 1.0 Regression Tests

  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/idbcore_regression_sequential_service_with_timeouts/idbcore_regression_sequential_service_with_timeouts_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/idbcore_regression_sequential_service_with_timeouts/idbcore_regression_sequential_service_with_timeouts_1.0_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=idbcore_regression_sequential_service_with_timeouts&policyVersion=1.0'

  @idbcore_regression_sequential_service_with_timeouts_1.0_tag1
  Scenario: Basic success scenario of Service1
    * set req_headers.business-event = 'testService1'
    * call wfResponse { payload: '#(payloads.idbcore_regression_sequential_service_with_timeouts_basic_req)', response: '#(responses.idbcore_regression_sequential_service_with_timeouts_basic_resp)', httpStatus: 200 }

  @idbcore_regression_sequential_service_with_timeouts_1.0_tag2
  Scenario: Basic failure scenario of Service2
    * set req_headers.business-event = 'testService2'
    * call wfResponse { payload: '#(payloads.idbcore_regression_sequential_service_with_timeouts_basic_req)', response: '#(responses.idbcore_regression_sequential_service_with_timeouts_basic_resp2)', httpStatus: 200 }

  @idbcore_regression_sequential_service_with_timeouts_1.0_tag3
  Scenario: Basic success scenario of Service1 after Service2 has been run
    * set req_headers.business-event = 'testService1'
    * call wfResponse { payload: '#(payloads.idbcore_regression_sequential_service_with_timeouts_basic_req)', response: '#(responses.idbcore_regression_sequential_service_with_timeouts_basic_resp)', httpStatus: 200 }