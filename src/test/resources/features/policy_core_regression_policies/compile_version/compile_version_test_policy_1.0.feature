@compile_version_tag
Feature: Compile Version Tests

  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/compile_version/idbcore_compile_version_test_policy_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/compile_version/idbcore_compile_version_test_policy_1.0_response.yml')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=idbcore_compile_version_test_policy&policyVersion=1.0'

  Scenario: Validate Masterbuilder API can successfully load a policy with compile version 2 specified in policy-metadata.json
    * call wfResponse { payload: '#(payloads.compile_version_1_0_req)', response: '#(responses.compile_version_1_0_resp)', httpStatus: 200 }
