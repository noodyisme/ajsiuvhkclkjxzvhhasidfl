@mb_2_0_regression_parameter_validation_1.0_tag
Feature: MB2 Parameter Validation 1.0 Regression Tests

  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/mb_2_0_regression_parameter_validation/mb_2_0_regression_parameter_validation_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/mb_2_0_regression_parameter_validation/mb_2_0_regression_parameter_validation_1.0_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=mb_2_0_regression_parameter_validation&policyVersion=1.0'

  @mb_2_0_regression_parameter_validation_1.0_tag1
  Scenario: Basic successful scenario
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_parameter_validation_basic_req)', response: '#(responses.mb_2_0_regression_parameter_validation_successful_resp)', httpStatus: 200 }

  @mb_2_0_regression_parameter_validation_1.0_tag2
  Scenario: Passed invalid state code
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_parameter_validation_invalid_state_req)', response: '#(responses.mb_2_0_regression_parameter_validation_schema_failure_resp)', httpStatus: 200 }

  @mb_2_0_regression_parameter_validation_1.0_tag3
  Scenario: Passed non-string state code
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_parameter_validation_nonstring_state_req)', response: '#(responses.mb_2_0_regression_parameter_validation_schema_failure_resp)', httpStatus: 200 }

  @mb_2_0_regression_parameter_validation_1.0_tag4
  Scenario: Passed lowercase state code
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_parameter_validation_lowercase_state_req)', response: '#(responses.mb_2_0_regression_parameter_validation_schema_failure_resp)', httpStatus: 200 }

  @mb_2_0_regression_parameter_validation_1.0_tag5
  Scenario: Passed valid, but not recognized state code
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_parameter_validation_unrecognized_state_req)', response: '#(responses.mb_2_0_regression_parameter_validation_schema_failure_resp)', httpStatus: 200 }

  @mb_2_0_regression_parameter_validation_1.0_tag6
  Scenario: Passed invalid phone number
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_parameter_validation_invalid_phone_req)', response: '#(responses.mb_2_0_regression_parameter_validation_schema_failure_resp)', httpStatus: 200 }

  @mb_2_0_regression_parameter_validation_1.0_tag7
  Scenario: Passed non-string phone number
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_parameter_validation_integer_phone_req)', response: '#(responses.mb_2_0_regression_parameter_validation_schema_failure_resp)', httpStatus: 200 }

  @mb_2_0_regression_parameter_validation_1.0_tag8
  Scenario: Passed invalid date time
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_parameter_validation_invalid_dateTime_req)', response: '#(responses.mb_2_0_regression_parameter_validation_schema_failure_resp)', httpStatus: 200 }

  @mb_2_0_regression_parameter_validation_1.0_tag9
  Scenario: Passed valid boolean false case
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_parameter_validation_false_boolean_req)', response: '#(responses.mb_2_0_regression_parameter_validation_successful_resp)', httpStatus: 200 }

  @mb_2_0_regression_parameter_validation_1.0_tag10
  Scenario: Passed boolean as string
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_parameter_validation_invalid_boolean_req)', response: '#(responses.mb_2_0_regression_parameter_validation_schema_failure_resp)', httpStatus: 200 }

  @mb_2_0_regression_parameter_validation_1.0_tag11
  Scenario: Don't pass required phone number
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_parameter_validation_missing_phone_req)', response: '#(responses.mb_2_0_regression_parameter_validation_schema_failure_resp)', httpStatus: 200 }

  @mb_2_0_regression_parameter_validation_1.0_tag12
  Scenario: Don't pass optional isEnrolled
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_parameter_validation_missing_isEnrolled_req)', response: '#(responses.mb_2_0_regression_parameter_validation_successful_missing_boolean_resp)', httpStatus: 200 }