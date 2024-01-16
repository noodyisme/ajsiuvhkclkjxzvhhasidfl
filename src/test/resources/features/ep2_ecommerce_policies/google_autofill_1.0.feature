 @google_autofill_1.0_tag
 Feature: Google Autofill 1.0 integration tests
 
 ########################### defining requests and responses
  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/google_autofill/google_autofill_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/google_autofill/google_autofill_1.0_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * def noWfResponse = read('classpath:features/utilities/one_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=google_autofill&policyVersion=1.0'

     ###################### Positive Scenario #########################

   @google_autofill_1.0_tag1
   Scenario: Validating Success scenario for Google Autofill with mandatory fields
     * call wfResponse { payload: '#(payloads.google_autofill_req)', response: '#(responses.google_autofill_response)', httpStatus: 200 }

     ###################### Error Scenarios #########################

   @google_autofill_1.0_tag2
   Scenario: Validating Unhappy path for Google Autofill Policy with missing mandatory fields
     * call wfResponse { payload: '#(payloads.google_autofill_missing_profilereferenceid_req)', response: '#(responses.google_autofill_missing_profilereferenceid_resp)', httpStatus: 200 }