@mb_2_0_regression_SDPv4_1.0_tag
Feature: MB2 SDPv4 1.0 Regression Tests

  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/mb_2_0_regression_SDPv4/mb_2_0_regression_SDPv4_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/mb_2_0_regression_SDPv4/mb_2_0_regression_SDPv4_1.0_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=mb_2_0_regression_SDPv4&policyVersion=1.0'

  @mb_2_0_regression_SDPv4_1.0_tag1
  Scenario: Basic Scenario w/ name 1
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_SDPv4_successful_1_req)', response: '#(responses.mb_2_0_regression_SDPv4_successful_1_resp)', httpStatus: 200 }

  @mb_2_0_regression_SDPv4_1.0_tag2
  Scenario: Basic Scenario w/ name 2
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_SDPv4_successful_2_req)', response: '#(responses.mb_2_0_regression_SDPv4_successful_2_resp)', httpStatus: 200 }