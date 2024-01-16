@mb_2_0_regression_parallel_downstream_apis_1.0_tag
Feature: MB2 Parallel Downstream APIs 1.0 Regression Tests

  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/mb_2_0_regression_parallel_downstream_apis/mb_2_0_regression_parallel_downstream_apis_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/mb_2_0_regression_parallel_downstream_apis/mb_2_0_regression_parallel_downstream_apis_1.0_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=mb_2_0_regression_parallel_downstream_apis&policyVersion=1.0'

  @mb_2_0_regression_parallel_downstream_apis_1.0_tag1
  Scenario: Basic successful scenario
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_parallel_downstream_apis_successful_req)', response: '#(responses.mb_2_0_regression_parallel_downstream_apis_successful_resp)', httpStatus: 200 }