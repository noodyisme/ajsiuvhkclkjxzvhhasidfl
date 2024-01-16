@mb_2_0_regression_redis_1.0_tag
Feature: MB2 Redis 1.0 Regression Tests

  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/mb_2_0_regression_redis/mb_2_0_regression_redis_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/mb_2_0_regression_redis/mb_2_0_regression_redis_1.0_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=mb_2_0_regression_redis&policyVersion=1.0'

  @mb_2_0_regression_redis_1.0_tag1
  Scenario: Basic successful scenario
    * def step1Response = call wfResponse { payload: '#(payloads.mb_2_0_regression_redis_step1_req)', response: '#(responses.mb_2_0_regression_redis_step1_resp)', httpStatus: 200 }
    * def policyProcessId = step1Response.response.metadata.policyProcessId
    * def URL = URL.substring(0, URL.indexOf('initiate-policy')) + 'policy-processes/' + policyProcessId + '/continue-process?step=step2'
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_redis_step2_req)', response: '#(responses.mb_2_0_regression_redis_step2_resp)', httpStatus: 200 }
    * def URL = URL.substring(0, URL.indexOf('step2')) + 'step3'
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_redis_step3_req)', response: '#(responses.mb_2_0_regression_redis_step3_resp)', httpStatus: 200 }

  @mb_2_0_regression_redis_1.0_tag2
  Scenario: Skip step 2, Start -> step 3
    * def step1Response = call wfResponse { payload: '#(payloads.mb_2_0_regression_redis_step1_req)', response: '#(responses.mb_2_0_regression_redis_step1_resp)', httpStatus: 200 }
    * def policyProcessId = step1Response.response.metadata.policyProcessId
    * def URL = URL.substring(0, URL.indexOf('initiate-policy')) + 'policy-processes/' + policyProcessId + '/continue-process?step=step3'
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_redis_step3_req)', response: '#(responses.mb_2_0_regression_redis_step3_unavailable_resp)', httpStatus: 404 }

  @mb_2_0_regression_redis_1.0_tag3
  Scenario: Invalid policy process ID
    * def step1Response = call wfResponse { payload: '#(payloads.mb_2_0_regression_redis_step1_req)', response: '#(responses.mb_2_0_regression_redis_step1_resp)', httpStatus: 200 }
    * def policyProcessId = 'abc123'
    * def URL = URL.substring(0, URL.indexOf('initiate-policy')) + 'policy-processes/' + policyProcessId + '/continue-process?step=step2'
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_redis_step2_req)', response: '#(responses.mb_2_0_regression_redis_step2_invalid_id_resp)', httpStatus: 404 }

  @mb_2_0_regression_redis_1.0_tag4
  Scenario: Attempt last step again after execution finishes
    * def step1Response = call wfResponse { payload: '#(payloads.mb_2_0_regression_redis_step1_req)', response: '#(responses.mb_2_0_regression_redis_step1_resp)', httpStatus: 200 }
    * def policyProcessId = step1Response.response.metadata.policyProcessId
    * def URL = URL.substring(0, URL.indexOf('initiate-policy')) + 'policy-processes/' + policyProcessId + '/continue-process?step=step2'
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_redis_step2_req)', response: '#(responses.mb_2_0_regression_redis_step2_resp)', httpStatus: 200 }
    * def URL = URL.substring(0, URL.indexOf('step2')) + 'step3'
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_redis_step3_req)', response: '#(responses.mb_2_0_regression_redis_step3_resp)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_redis_step3_req)', response: '#(responses.mb_2_0_regression_redis_step3_policy_already_finished_resp)', httpStatus: 404 }

  @mb_2_0_regression_redis_1.0_tag5
  Scenario: Attempt step 2 twice
    * def step1Response = call wfResponse { payload: '#(payloads.mb_2_0_regression_redis_step1_req)', response: '#(responses.mb_2_0_regression_redis_step1_resp)', httpStatus: 200 }
    * def policyProcessId = step1Response.response.metadata.policyProcessId
    * def URL = URL.substring(0, URL.indexOf('initiate-policy')) + 'policy-processes/' + policyProcessId + '/continue-process?step=step2'
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_redis_step2_req)', response: '#(responses.mb_2_0_regression_redis_step2_resp)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_redis_step2_req)', response: '#(responses.mb_2_0_regression_redis_step2_already_completed_resp)', httpStatus: 404 }