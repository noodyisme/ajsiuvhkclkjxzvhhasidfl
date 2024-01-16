@cardfraud_account_lookup_1.1_tag
Feature: Cardfraud Account Lookup API integration tests

 ########################### defining requests and responses

  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/account_lookup/account_lookup_1.1_payload.yml')
    * def responses = read('classpath:config/data/responses/account_lookup/account_lookup_1.1_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * def noWfResponse = read('classpath:features/utilities/one_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=account_lookup&policyVersion=1.1'

  ###################### Required Fields Missing ##################

  @cardfraud_account_lookup_1.1_tag1
  Scenario: Validating failure on missing required fields
    * call wfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.account_lookup_missing_customerReferenceIds_field_req)', response: '#(responses.account_lookup_missing_customerReferenceIds_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.account_lookup_missing_brandCode_field_req)', response: '#(responses.account_lookup_missing_brandCode_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.account_lookup_missing_originator_field_req)', response: '#(responses.account_lookup_missing_originator_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.1_tag2
  Scenario: Validating failure on missing govtIdRequest required fields
    * call wfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_barcode_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_barcode_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_deviceId_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_deviceId_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_businessUnit_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_businessUnit_field_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_model_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_model_field_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_copyText_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_copyText_field_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_configId_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_configId_field_response)', httpStatus: 200 }

  ###################### Invalid Required Fields ##################

  @cardfraud_account_lookup_1.1_tag3
  Scenario: Validating Schema Validation failure on empty string customerReferenceIds (INVALID)
    * call wfResponse { payload: '#(payloads.account_lookup_customerReferenceIds_Null_req)', response: '#(responses.account_lookup_missing_customerReferenceIds_Null_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.1_tag4
  Scenario: Validating failure on invalid barcode (Unknown, BadPicture)
    * call wfResponse { payload: '#(payloads.account_lookup_govtIdRequest_barcode_invalid_req)', response: '#(responses.account_lookup_govtIdRequest_barcode_invalid_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.1_tag5
  Scenario: Validating failure on invalid customReferenceId (NonDefinitive) - broken, returning currently Access denied due to permission
    * call wfResponse { payload: '#(payloads.account_lookup_invalid_customerRefId_req)', response: '#(responses.account_lookup_invalid_customerRefId_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.1_tag6
  Scenario: Validating barcode_retrieve Schema Validation Failure on empty string model (FAILURE)
    * call noWfResponse { payload: '#(payloads.account_lookup_emptyModel_req)', response: '#(responses.account_lookup_emptyModel_response)', httpStatus: 200}

  @cardfraud_account_lookup_1.1_tag7
  Scenario: Validating failure for business customerReferenceId (NonDefinitive)
    * call wfResponse { payload: '#(payloads.account_lookup_business_customerReferenceId_req)', response: '#(responses.account_lookup_business_customerReferenceId_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.1_tag8
  Scenario: Validating failure for invalid location (NonDefinitive)
    * call wfResponse { payload: '#(payloads.account_lookup_invalid_location_req)', response: '#(responses.account_lookup_invalid_location_response)', httpStatus: 200 }

  ##################### Positive Scenarios ########################

  @cardfraud_account_lookup_1.1_tag9
  Scenario: Validating success for a GA ID with matching DOB (Passed)
    * call wfResponse { payload: '#(payloads.account_lookup_successful_matching_req)', response: '#(responses.account_lookup_successful_matching_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.1_tag10
  Scenario: Validating success for mix of valid and invalid customerReferenceIds (Passed, NonDefinitive, NonDefinitive)
    * call wfResponse { payload: '#(payloads.account_lookup_invalid_skipInvalidCustomerRefId_req)', response: '#(responses.account_lookup_invalid_skipInvalidCustomerRefId_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.1_tag11
  Scenario: Validating success for a MN ID with null expiration date matching DOB (Passed)
    * call wfResponse { payload: '#(payloads.account_lookup_successful_mn_no_expiry_dob_match_req)', response: '#(responses.account_lookup_successful_mn_no_expiry_dob_match_response)', httpStatus: 200 }

  ##################### Failed Scenarios ##########################

  @cardfraud_account_lookup_1.1_tag12
  Scenario: Validating failure for Date of Birth mismatch between GA ID and FL person (DateOfBirthMismatch)
    * call wfResponse { payload: '#(payloads.account_lookup_dob_mismatch_req)', response: '#(responses.account_lookup_dob_mismatch_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.1_tag13
  Scenario: Validating failure for ID expired more than 90 days (Expired)
    * call wfResponse { payload: '#(payloads.account_lookup_expiration_date_expired_over90days_req)', response: '#(responses.account_lookup_expiration_date_expired_over90days_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.1_tag14
  Scenario: Validating failure for a PR ID with matching DOB and mismatched name ()
    * call wfResponse { payload: '#(payloads.account_lookup_pr_dob_match_name_mismatch_req)', response: '#(responses.account_lookup_pr_dob_match_name_mismatch_response)', httpStatus: 200 }