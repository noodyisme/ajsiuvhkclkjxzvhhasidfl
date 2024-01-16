@cardfraud_account_lookup_1.2_tag
Feature: Cardfraud Account Lookup API integration tests

 ########################### defining requests and responses

  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/account_lookup/account_lookup_1.2_payload.yml')
    * def responses = read('classpath:config/data/responses/account_lookup/account_lookup_1.2_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * def noWfResponse = read('classpath:features/utilities/one_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=account_lookup&policyVersion=1.2'

  ###################### Required Fields Missing ##################

  @cardfraud_account_lookup_1.2_tag1
  Scenario: Validating failure on missing required fields
    * call wfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.account_lookup_missing_customerReferenceIds_field_req)', response: '#(responses.account_lookup_missing_customerReferenceIds_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.account_lookup_missing_brandCode_field_req)', response: '#(responses.account_lookup_missing_brandCode_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.account_lookup_missing_originator_field_req)', response: '#(responses.account_lookup_missing_originator_response)', httpStatus: 200 }

  @cardfraud_account_lookup_1.2_tag2
  Scenario: Validating failure on missing govtIdRequest required fields
    * call wfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_barcode_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_barcode_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_deviceId_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_deviceId_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_businessUnit_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_businessUnit_field_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_model_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_model_field_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_copyText_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_copyText_field_response)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.account_lookup_missing_govtIdRequest_configId_field_req)', response: '#(responses.account_lookup_missing_govtIdRequest_configId_field_response)', httpStatus: 200 }