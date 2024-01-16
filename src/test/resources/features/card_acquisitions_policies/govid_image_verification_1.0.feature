@govid_image_verification_1.0_tag
Feature: GOVID image verification 1.0 integration tests

 ########################### defining requests and responses
  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/govid_image_verification/govid_image_verification_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/govid_image_verification/govid_image_verification_1.0_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * def noWfResponse = read('classpath:features/utilities/one_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=govid_image_verification&policyVersion=1.0'

     ###################### Positive Scenario #########################

  @govid_image_verificationl_1.0_tag1
  Scenario: Validating Success scenario for Govid image verification mandatory fields
    * call wfResponse { payload: '#(payloads.govid_image_verification_req)', response: '#(responses.govid_image_verification_response)', httpStatus: 200 }

     ###################### Error Scenarios #########################

  @govid_image_verification_1.0_tag2
  Scenario: Validating Unhappy path for Google Autofill Policy with missing mandatory fields
    * call wfResponse { payload: '#(payloads.govid_image_verification_missing_businessunit_req)', response: '#(responses.govid_image_verification_missing_businessunit_response)', httpStatus: 200 }


