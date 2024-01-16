@delegation_pattern_tag
Feature: MB3 Policy Path Parameter & MB2 Policy Query Parameter Regression Tests

  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/pc_regression_delegation_pattern_policy_routing/pc_regression_delegation_pattern_policy_routing_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/pc_regression_delegation_pattern_policy_routing/pc_regression_delegation_pattern_policy_routing_1.0_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def queryURL = URL + '?policyName=idbcore_regression_delegation_pattern_policy_routing&policyVersion=1.0'
    * def fullNamePolicyPathURL = URL + '/us_consumers/ep2_identity_builder_test/idbcore_regression_delegation_pattern_policy_routing/1.0'
    * def shortNamePolicyPathURL = URL + '/idbcore_regression_delegation_pattern_policy_routing/1.0'

  @pc_regression_public_policy_resource_with_query_params
  Scenario: Basic request success with Query params
    * def URL = queryURL
    * call wfResponse { payload: '#(payloads.pc_regression_basic_req)', response: '#(responses.pc_regression_basic_successful_resp)', httpStatus: 200 }


  @pc_regression_public_policy_resource_with_path_params
  Scenario: Basic request success with full Policy Addressing
    * def URL = shortNamePolicyPathURL
    * call wfResponse { payload: '#(payloads.pc_regression_basic_req)', response: '#(responses.pc_regression_basic_successful_resp)', httpStatus: 200 }

  @pc_regression_public_policy_resource_with_path_params
  Scenario: Basic bad request failure with simple Policy Addressing
    * def URL = fullNamePolicyPathURL
    * call wfResponse { payload: '#(payloads.pc_regression_basic_req)', response: '#(responses.pc_regression_basic_bad_request_resp)', httpStatus: 404 }