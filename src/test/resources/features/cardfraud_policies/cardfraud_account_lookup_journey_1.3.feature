@cardfraud_account_lookup_1.3_tag
Feature: Cardfraud Account Lookup API integration tests

 ########################### defining requests and responses

  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/account_lookup/account_lookup_1.3_payload.yml')
    * def responses = read('classpath:config/data/responses/account_lookup/account_lookup_1.3_response.yml')
    * def noWfResponse = read('classpath:features/utilities/one_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=account_lookup&policyVersion=1.3'

  ###################### Required Fields Missing ##################

  @cardfraud_account_lookup_1.3_tag1
  Scenario: Validating failure on missing required fields
    * call noWfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_response)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.account_lookup_missing_customerReferenceIds_field_req)', response: '#(responses.account_lookup_missing_customerReferenceIds_response)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.account_lookup_missing_brandCode_field_req)', response: '#(responses.account_lookup_missing_brandCode_response)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.account_lookup_missing_originator_field_req)', response: '#(responses.account_lookup_missing_originator_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.3_tag2
  Scenario: Validating failure on missing govtIdRequest required fields
    * call noWfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_barcode_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_barcode_response)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_deviceId_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_deviceId_response)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_businessUnit_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_businessUnit_field_response)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_model_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_model_field_response)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_copyText_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_copyText_field_response)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_configId_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_configId_field_response)', httpStatus: 200 }

  ###################### Invalid Required Fields ##################

  @cardfraud_account_lookup_1.3_tag3
  Scenario: Validating Schema Validation failure on invalid originator (INVALID)
    * call noWfResponse { payload: '#(payloads.account_lookup_invalid_originator_req)', response: '#(responses.account_lookup_invalid_originator_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.3_tag4
  Scenario: Validating Schema Validation failure on invalid brandCode (INVALID)
    * call noWfResponse { payload: '#(payloads.account_lookup_invalid_brandCode_req)', response: '#(responses.account_lookup_invalid_brandCode_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.3_tag5
  Scenario: Validating Schema Validation failure on null customerReferenceIds (INVALID)
    * call noWfResponse { payload: '#(payloads.account_lookup_customerReferenceIds_Null_req)', response: '#(responses.account_lookup_missing_customerReferenceIds_Null_response)', httpStatus: 200 }

  ###################### Error Responses from Endpoints ###########

  @cardfraud_account_lookup_1.3_tag6
  Scenario: Validating failure for invalid location (FAILURE)
    * call noWfResponse { payload: '#(payloads.account_lookup_invalid_location_req)', response: '#(responses.account_lookup_invalid_location_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.3_tag7
  Scenario: Validating barcode_retrieve Schema Validation Failure on empty string model (FAILURE)
    * call noWfResponse { payload: '#(payloads.account_lookup_empty_model_req)', response: '#(responses.account_lookup_empty_model_response)', httpStatus: 200}

  @cardfraud_account_lookup_1.3_tag8
  Scenario: Validating failure on invalid customReferenceId (NonDefinitive)
    * call noWfResponse { payload: '#(payloads.account_lookup_invalid_customerRefId_req)', response: '#(responses.account_lookup_invalid_customerRefId_response)', httpStatus: 200 }

  ###################### Failed Scenarios #########################

  @cardfraud_account_lookup_1.3_tag9
  Scenario: Validating failure on invalid barcode (Unknown, BadPicture)
    * call noWfResponse { payload: '#(payloads.account_lookup_govtIdRequest_barcode_invalid_req)', response: '#(responses.account_lookup_govtIdRequest_barcode_invalid_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.3_tag10
  Scenario: Validating failure for Date of Birth mismatch between GA ID and FL person (Failed, DateOfBirthMismatch)
    * call noWfResponse { payload: '#(payloads.account_lookup_dob_mismatch_req)', response: '#(responses.account_lookup_dob_mismatch_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.3_tag11
  Scenario: Validating failure for ID expired more than 90 days (Failed, Expired)
    * call noWfResponse { payload: '#(payloads.account_lookup_expiration_date_expired_over90days_req)', response: '#(responses.account_lookup_expiration_date_expired_over90days_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.3_tag12
  Scenario: Validating failure for a PR ID with matching DOB and mismatched name (Failed, fullNameMismatch)
    * call noWfResponse { payload: '#(payloads.account_lookup_pr_dob_match_name_mismatch_req)', response: '#(responses.account_lookup_pr_dob_match_name_mismatch_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.3_tag13
  Scenario: Validating failure for a PR ID with no DOB and mismatched name (Failed, NoDateOfBirthNameMismatch)
    * call noWfResponse { payload: '#(payloads.account_lookup_pr_no_dob_name_mismatch_req)', response: '#(responses.account_lookup_pr_no_dob_name_mismatch_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.3_tag14
  Scenario: Validating failure for a PR ID with DOB mismatch (Failed, NoDateOfBirthNameMismatch)
    * call noWfResponse { payload: '#(payloads.account_lookup_pr_dob_mismatch_req)', response: '#(responses.account_lookup_pr_dob_mismatch_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.3_tag15
  Scenario: Validating failure for business customerReferenceId (NonDefinitive)
    * call noWfResponse { payload: '#(payloads.account_lookup_business_customerReferenceId_req)', response: '#(responses.account_lookup_business_customerReferenceId_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.3_tag16
  Scenario: Validating failure for a FL ID with no DOB (Failed, invalidId)
    * call noWfResponse { payload: '#(payloads.account_lookup_fl_no_dob_req)', response: '#(responses.account_lookup_fl_no_dob_response)', httpStatus: 200 }

  ##################### Positive Scenarios #######################

  @cardfraud_account_lookup_1.3_tag9
  Scenario: Validating success for a GA ID with matching DOB (Passed)
    * call noWfResponse { payload: '#(payloads.account_lookup_successful_matching_req)', response: '#(responses.account_lookup_successful_matching_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.3_tag10
  Scenario: Validating success for mix of valid and invalid customerReferenceIds (Passed, NonDefinitive, NonDefinitive)
    * call noWfResponse { payload: '#(payloads.account_lookup_invalid_skipInvalidCustomerRefId_req)', response: '#(responses.account_lookup_invalid_skipInvalidCustomerRefId_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.3_tag11
  Scenario: Validating success for a MN ID with null expiration date matching DOB (Passed)
    * call noWfResponse { payload: '#(payloads.account_lookup_successful_mn_no_expiry_dob_match_req)', response: '#(responses.account_lookup_successful_mn_no_expiry_dob_match_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.3_tag12
  Scenario: Validating success for a PR ID with DOB and PR ID with no DOB matching on name (Passed)
    * call noWfResponse { payload: '#(payloads.account_lookup_pr_with_no_dob_matching_customer_with_dob_req)', response: '#(responses.account_lookup_pr_with_no_dob_matching_customer_with_dob_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.3_tag13
  Scenario: Validating success for a PR ID with no DOB and PR ID with no DOB matching on name (Passed)
    * call noWfResponse { payload: '#(payloads.account_lookup_pr_with_no_dob_matching_customer_with_no_dob_req)', response: '#(responses.account_lookup_pr_with_no_dob_matching_customer_with_no_dob_response)', httpStatus: 200 }