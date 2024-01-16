 @test_policy_1.0_tag
 Feature: Cardfraud IVH payfone API integration tests
 
 ########################### defining requests and responses
  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/test_policy/test_policy_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/test_policy/test_policy_1.0_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * def noWfResponse = read('classpath:features/utilities/one_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=test_policy&policyVersion=1.0'


    ###################### Positive Scenario #########################

  @test_policy_1.0_tag1
  Scenario: Validating Success scenario for MNO payfone Policy with mandatory fields
    * call wfResponse { payload: '#(payloads.test_policy_required_fields_req)', response: '#(responses.test_policy_response)', httpStatus: 200 }
    
    ###################### Error Scenarios #########################

  @test_policy_1.0_tag2
  Scenario: Validating Unhappy path for MNO payfone Policy with missing mandatory fields
    * call noWfResponse { payload: '#(payloads.test_policy_missing_first_name_req)', response: '#(responses.test_policy_missing_first_name_resp)', httpStatus: 200 }

    