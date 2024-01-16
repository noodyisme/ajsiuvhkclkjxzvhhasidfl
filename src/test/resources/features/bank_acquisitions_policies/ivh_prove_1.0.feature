@ivh_prove_1.0_tag
Feature: IVH Prove Integration Tests

  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/ivh_prove/ivh_prove_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/ivh_prove/ivh_prove_1.0_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * def noWfResponse = read('classpath:features/utilities/one_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=ivh_prove&policyVersion=1.0'

  ###################### Positive Scenarios #########################
  @ivh_prove_1.0_tag1
  Scenario: Validating Success scenario for IVH Prove Policy with trusted summary
    * call wfResponse { payload: '#(payloads.ivh_prove_trusted_prepaid_atnt)', response: '#(responses.ivh_prove_response_success_trusted)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_trusted_prepaid_metropcs)', response: '#(responses.ivh_prove_response_success_trusted)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_trusted_prepaid_sprint)', response: '#(responses.ivh_prove_response_success_trusted)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_trusted_postpaid)', response: '#(responses.ivh_prove_response_success_trusted)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_trusted_first_name_less_than_80)', response: '#(responses.ivh_prove_response_success_trusted)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_trusted_last_name_less_than_80)', response: '#(responses.ivh_prove_response_success_trusted)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_trusted_verizon)', response: '#(responses.ivh_prove_response_success_trusted)', httpStatus: 200 }

  @ivh_prove_1.0_tag2
  Scenario: Validating Success scenario for IVH Prove Policy with untrusted summary
    * call wfResponse { payload: '#(payloads.ivh_prove_not_trusted_simSwapTimestamp)', response: '#(responses.ivh_prove_success_not_trusted)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_not_trusted_address_less_than_80)', response: '#(responses.ivh_prove_success_not_trusted)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_not_trusted_first_and_last_name_less_than_80)', response: '#(responses.ivh_prove_success_not_trusted)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_not_trusted_service_status_unknown)', response: '#(responses.ivh_prove_success_not_trusted)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_not_trusted_service_status_unknown_bad_account_tenure)', response: '#(responses.ivh_prove_success_not_trusted)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_not_trusted_prepaid_bad_account_tenure)', response: '#(responses.ivh_prove_success_not_trusted)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_not_trusted_postpaid_bad_account_tenure)', response: '#(responses.ivh_prove_success_not_trusted)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_not_trusted_port_timestamp_less_than_two_days)', response: '#(responses.ivh_prove_success_not_trusted)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_not_trusted_landline_line_type)', response: '#(responses.ivh_prove_success_not_trusted)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_not_trusted_unknown_tmobile)', response: '#(responses.ivh_prove_success_not_trusted)', httpStatus: 200 }

  @ivh_prove_1.0_tag3
  Scenario: Validating Success scenario for IVH Prove Policy with service unavailable summary
    * call wfResponse { payload: '#(payloads.ivh_prove_service_unavailable)', response: '#(responses.ivh_prove_success_service_unavailable)', httpStatus: 200 }

  @ivh_prove_1.0_tag4
  Scenario: Validating Success scenario for IVH Prove Policy with optionals
    * call wfResponse { payload: '#(payloads.ivh_prove_device_trusted_user_found_pass_no_brand_code)', response: '#(responses.ivh_prove_success)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_device_trusted_user_found_pass_no_originator_code)', response: '#(responses.ivh_prove_success)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.ivh_prove_device_trusted_user_found_pass_no_brand_code_no_originator_code)', response: '#(responses.ivh_prove_success)', httpStatus: 200 }

  ###################### Error Scenarios #########################
  @ivh_prove_1.0_tag5
  Scenario: Validating Unhappy path for IVH Prove Policy with missing mandatory field
    * call noWfResponse { payload: '#(payloads.ivh_prove_missing_first_name_req)', response: '#(responses.ivh_prove_missing_first_name_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_missing_last_name_req)', response: '#(responses.ivh_prove_missing_last_name_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_missing_MobilePhoneNumber_req)', response: '#(responses.ivh_prove_missing_MobilePhoneNumber_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_missing_AddressLine1_req)', response: '#(responses.ivh_prove_missing_AddressLine1_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_missing_City_req)', response: '#(responses.ivh_prove_missing_City_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_missing_StateCode_req)', response: '#(responses.ivh_prove_missing_StateCode_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_missing_PostalCode_req)', response: '#(responses.ivh_prove_missing_PostalCode_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_missing_OptInMethod_req)', response: '#(responses.ivh_prove_missing_OptInMethod_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_missing_OptInTimestamp_req)', response: '#(responses.ivh_prove_missing_OptInTimestamp_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_missing_OptInDuration_req)', response: '#(responses.ivh_prove_missing_OptInDuration_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_missing_personalDetails_req)', response: '#(responses.ivh_prove_missing_personalDetails_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_missing_mnoDetails_req)', response: '#(responses.ivh_prove_missing_mnoDetails_resp)', httpStatus: 200 }

  @ivh_prove_1.0_tag6
  Scenario: Validating Scenarios for IVH Prove Policy with invalid data in field
    * call noWfResponse { payload: '#(payloads.ivh_prove_invalid_mobile_phone_number_req)', response: '#(responses.ivh_prove_invalid_mobile_phone_number_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_invalid_country_code_req)', response: '#(responses.ivh_prove_invalid_country_code_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_invalid_dateOfBirth_req)', response: '#(responses.ivh_prove_invalid_dateOfBirth_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_invalid_postal_code_req)', response: '#(responses.ivh_prove_invalid_postal_code_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_invalid_state_code_req)', response: '#(responses.ivh_prove_invalid_state_code_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_invalid_first_name_req)', response: '#(responses.ivh_prove_invalid_first_name_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_empty_first_name_req)', response: '#(responses.ivh_prove_empty_first_name_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_invalid_last_name_req)', response: '#(responses.ivh_prove_invalid_last_name_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_empty_last_name_req)', response: '#(responses.ivh_prove_empty_last_name_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_empty_addressLine1_req)', response: '#(responses.ivh_prove_empty_addressLine1_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_empty_city_req)', response: '#(responses.ivh_prove_empty_city_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_invalid_optIn_method_req)', response: '#(responses.ivh_prove_invalid_optIn_method_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_invalid_optIn_time_stamp_req)', response: '#(responses.ivh_prove_invalid_optIn_time_resp)', httpStatus: 200 }
    * call noWfResponse { payload: '#(payloads.ivh_prove_invalid_optIn_duration_req)', response: '#(responses.ivh_prove_invalid_optIn_duration_resp)', httpStatus: 200 }
