@barcode_matching_1.0_tag
Feature: Barcode Matching 1.0 API integration tests

 ########################### defining requests and responses
  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/barcode_matching/barcode_matching_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/barcode_matching/barcode_matching_1.0_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * def noWfResponse = read('classpath:features/utilities/one_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=barcode_matching&policyVersion=1.0'

  ###################### Required Fields Missing ##################
  @barcode_matching_1.0_tag1
  Scenario: Validating failure on missing required fields
    * call wfResponse { payload: '#(payloads.barcode_matching_missing_barcode_field_req)', response: '#(responses.barcode_matching_missing_barcode_field_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.barcode_matching_missing_deviceId_field_req)', response: '#(responses.barcode_matching_missing_deviceId_field_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.barcode_matching_missing_businessUnit_field_req)', response: '#(responses.barcode_matching_missing_businessUnit_field_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.barcode_matching_missing_model_field_req)', response: '#(responses.barcode_matching_missing_model_field_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.barcode_matching_missing_copyText_field_req)', response: '#(responses.barcode_matching_missing_copyText_field_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.barcode_matching_missing_customerReferenceId_field_req)', response: '#(responses.barcode_matching_missing_customerReferenceId_field_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.barcode_matching_missing_profileReferenceId_field_req)', response: '#(responses.barcode_matching_missing_profileReferenceId_field_response)', httpStatus: 200 }

  ###################### Invalid Required Fields ##################
  @barcode_matching_1.0_tag2
  Scenario: Validating Schema Validation failure on empty string customerReferenceId (INVALID)
    * call wfResponse { payload: '#(payloads.barcode_matching_customerReferenceId_empty_req)', response: '#(responses.barcode_matching_customerReferenceId_empty_response)', httpStatus: 200 }

  @barcode_matching_1.0_tag3
  Scenario: Validating failure on invalid barcode (Unknown, BadPicture)
    * call wfResponse { payload: '#(payloads.barcode_matching_barcode_invalid_req)', response: '#(responses.barcode_matching_barcode_invalid_response)', httpStatus: 200 }

  @barcode_matching_1.0_tag4
  Scenario: Validating failure on invalid customReferenceId (NonDefinitive) - broken, returning currently Access denied due to permission
    * def response = call wfResponse { payload: '#(payloads.barcode_matching_invalid_customerRefId_req)', response: '#(responses.barcode_matching_invalid_customerRefId_response)', httpStatus: 200 }
    # since the order of policyResponseBody.matchingResult.matchFailureReason.developerText in this response isn't always consistent, we can use a regex to match the different possiblities
    * def matchDeveloperText = 
      """
      function(developerText) {
        var regexes = [
          '("developerText":"Access denied due to permission: defaultGlobalAllow","id":200006,"text":"Looks like we need to fix something, so we\'re working on it\\. Try again in a bit, or give us a call at 1-877-383-4802\\.")',
          '("developerText":"Access denied due to permission: defaultGlobalAllow","text":"Looks like we need to fix something, so we\'re working on it\\. Try again in a bit, or give us a call at 1-877-383-4802\\.","id":200006)',
          '("id":200006,"developerText":"Access denied due to permission: defaultGlobalAllow","text":"Looks like we need to fix something, so we\'re working on it\\. Try again in a bit, or give us a call at 1-877-383-4802\\.")',
          '("id":200006,"text":"Looks like we need to fix something, so we\'re working on it\\. Try again in a bit, or give us a call at 1-877-383-4802\\.","developerText":"Access denied due to permission: defaultGlobalAllow")',
          '("text":"Looks like we need to fix something, so we\'re working on it\\. Try again in a bit, or give us a call at 1-877-383-4802\\.,"developerText":"Access denied due to permission: defaultGlobalAllow","id":200006")',
          '("text":"Looks like we need to fix something, so we\'re working on it\\. Try again in a bit, or give us a call at 1-877-383-4802\\.,"id":200006","developerText":"Access denied due to permission: defaultGlobalAllow")'
        ]
        return new RegExp(regexes.join('|')).test(developerText)
      }
      """
    * match response.response.policyResponseBody.matchingResult.matchFailureReason.developerText == '#? matchDeveloperText(_)'

  @barcode_matching_1.0_tag5
  Scenario: Validating barcode_retrieve Schema Validation Failure on empty string model (FAILURE)
    * call noWfResponse { payload: '#(payloads.barcode_matching_emptyModel_req)', response: '#(responses.barcode_matching_emptyModel_response)', httpStatus: 200}

  @barcode_matching_1.0_tag6
  Scenario: Validating failure for business customerReferenceId (NonDefinitive)
    * call wfResponse { payload: '#(payloads.barcode_matching_business_customerReferenceId_req)', response: '#(responses.barcode_matching_business_customerReferenceId_response)', httpStatus: 200 }

  @barcode_matching_1.0_tag7
  Scenario: Validating failure for invalid location (NonDefinitive)
    * call wfResponse { payload: '#(payloads.barcode_matching_invalid_location_req)', response: '#(responses.barcode_matching_invalid_location_response)', httpStatus: 200 }

  ##################### Positive Scenarios ########################
  @barcode_matching_1.0_tag8
  Scenario: Validating success for a GA ID with matching DOB (Passed)
    * call wfResponse { payload: '#(payloads.barcode_matching_successful_matching_req)', response: '#(responses.barcode_matching_successful_matching_response)', httpStatus: 200 }

  ##################### Failed Scenarios ##########################
  @barcode_matching_1.0_tag9
  Scenario: Validating failure for a MN ID with null expiration date matching DOB (NonDefinitive)
    * call wfResponse { payload: '#(payloads.barcode_matching_mn_no_expiry_dob_match_req)', response: '#(responses.barcode_matching_mn_no_expiry_dob_match_response)', httpStatus: 200 }

  @barcode_matching_1.0_tag10
  Scenario: Validating failure for Date of Birth mismatch between GA ID and FL person (DateOfBirthMismatch)
    * call wfResponse { payload: '#(payloads.barcode_matching_dob_mismatch_req)', response: '#(responses.barcode_matching_dob_mismatch_response)', httpStatus: 200 }

  @barcode_matching_1.0_tag11
  Scenario: Validating failure for ID expired more than 90 days (Expired)
    * call wfResponse { payload: '#(payloads.barcode_matching_expiration_date_expired_over90days_req)', response: '#(responses.barcode_matching_expiration_date_expired_over90days_response)', httpStatus: 200 }

  @barcode_matching_1.0_tag12
  Scenario: Validating failure for a PR ID with matching DOB and mismatched name (fullNameMismatch)
    * call wfResponse { payload: '#(payloads.barcode_matching_pr_dob_match_name_mismatch_req)', response: '#(responses.barcode_matching_pr_dob_match_name_mismatch_response)', httpStatus: 200 }
