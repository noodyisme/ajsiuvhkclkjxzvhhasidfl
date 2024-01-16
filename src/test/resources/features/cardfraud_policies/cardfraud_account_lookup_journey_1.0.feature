@cardfraud_account_lookup_journey_1.0_tag
Feature: Cardfraud GovidbarcodePrefil API integration tests

 ########################### defining requests and responses
  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/account_lookup/account_lookup_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/account_lookup/account_lookup_1.0_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * def noWfResponse = read('classpath:features/utilities/one_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=account_lookup&policyVersion=1.0'


    ###################### Error Scenario #########################

  @cardfraud_account_lookup_journey_1.0_tag1
  Scenario: Validating missing customerReferenceId in account look up Journey Policy
    * call wfResponse { payload: '#(payloads.account_lookup_missing_customerReferenceId_fields_req)', response: '#(responses.account_lookup_journey_missing_customerReferenceId_response)', httpStatus: 200 }

    ###################### Error Scenario #########################

  @cardfraud_account_lookup_journey_1.0_tag2
  Scenario: Validating missing barcode in account look up Journey Policy
    * call wfResponse { payload: '#(payloads.account_lookup_missing_govid_barcode_missing_req)', response: '#(responses.account_lookup_journey_missing_govid_barcode_response)', httpStatus: 200 }

  @cardfraud_account_lookup_journey_1.0_tag3
  Scenario: Validating missing barcode in account look up Journey Policy
     * call wfResponse { payload: '#(payloads.account_lookup_customerReferenceId_Null_req)', response: '#(responses.account_lookup_journey_missing_customerReferenceId_Null_response)', httpStatus: 200 }


    ##################### Positive Scenario #########################
  @cardfraud_account_lookup_journey_1.0_tag4
  Scenario: Successfull customer MatchingStatus
     * call wfResponse { payload: '#(payloads.account_lookup_successfull_matching_req)', response: '#(responses.account_lookup_successfull_matching_resp)', httpStatus: 200 }

  @cardfraud_account_lookup_journey_1.0_tag5
  Scenario: Date of Birth mismatch
    * call wfResponse { payload: '#(payloads.account_lookup_dob_mismatch_req)', response: '#(responses.account_lookup_journey_Dob_mismatch_resp)', httpStatus: 200 }

  @cardfraud_account_lookup_journey_1.0_tag6
  Scenario: Validating failed customerMatch Response
     * call wfResponse { payload: '#(payloads.account_lookup_journey_Failed_req)', response: '#(responses.account_lookup_journey_Failed_resp)', httpStatus: 200 }

  @cardfraud_account_lookup_journey_1.0_tag7
  Scenario: Validating empty matching result with invalid customer referenceId
     * call wfResponse { payload: '#(payloads.account_lookup_journey_invalid_customerRefId_req)', response: '#(responses.account_lookup_journey_invalid_customerRefId_resp)', httpStatus: 200 }


  @cardfraud_account_lookup_journey_1.0_tag8
  Scenario: skipping the invalid customer reference Ids and process the good ones
     * call wfResponse { payload: '#(payloads.account_lookup_journey_invalid_skipInvalidCustomerRefId_req)', response: '#(responses.account_lookup_journey_invalid_skipInvalidCustomerRefId_resp)', httpStatus: 200 }


  @cardfraud_account_lookup_journey_1.0_tag9
  Scenario: UnKnown DocumentStatus with BadPicture scenarios
    * call wfResponse { payload: '#(payloads.account_lookup_journey_Unknown_req)', response: '#(responses.account_lookup_journey_Unknown_resp)', httpStatus: 200 }

  @cardfraud_account_lookup_journey_1.0_tag10
  Scenario: Validating Unhappy path for account_lookup with empty model
    * call noWfResponse { payload: '#(payloads.account_lookup_journey_emptyModel_req)', response: '#(responses.account_lookup_journey_emptyModel_resp)', httpStatus: 200}

  @cardfraud_account_lookup_journey_1.0_tag11
  Scenario: Validating documentValidityStatus and documentFailureReason in the response
    * call noWfResponse { payload: '#(payloads.account_lookup_journey_documentValidityStatus_documentFailureReason_req)', response: '#(responses.account_lookup_journey_documentValidityStatus_documentFailureReason_resp)', httpStatus: 200}