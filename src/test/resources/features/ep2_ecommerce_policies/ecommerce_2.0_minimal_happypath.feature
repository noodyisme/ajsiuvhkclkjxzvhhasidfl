@ECommerce_2.0_min_tag
Feature: XCommerce 2.0 integration tests
 
 ########################### defining requests and responses
  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/ecommerce/ecommerce_2.0_payload.yml')
    * def responses = read('classpath:config/data/responses/ecommerce/ecommerce_2.0_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * def noWfResponse = read('classpath:features/utilities/one_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def baseURL = URL
    * def URL = URL + '?policyName=ecommerce_step_up&policyVersion=2.0'
    * copy reqHeadersCopy = req_headers


     ###################### Error Scenarios #########################

  @ECommerce_2.0_min_tag1
  Scenario: Validating Shared id as null with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_null_shared_id_param_req)', response: '#(responses.ecommerce_shared_id_error_resp)', httpStatus: 200 }


  @ECommerce_2.0_min_tag2
  Scenario: Validating Vendor id as null with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_null_vendor_id_param_req)', response: '#(responses.ecommerce_vender_id_error_resp)', httpStatus: 200 }

  @ECommerce_2.0_min_tag3
  Scenario: Validating profile reference id as null with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_null_profile_reference_id_req)', response: '#(responses.ecommerce_profile_reference_id_error_resp)', httpStatus: 200 }


  @ECommerce_2.0_min_tag4
  Scenario: Validating stage as null with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_null_stage_req)', response: '#(responses.ecommerce_stage_error_resp)', httpStatus: 200 }

  @ECommerce_2.0_min_tag5
  Scenario: Validating event name as null with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_null_event_name_req)', response: '#(responses.ecommerce_null_event_name_error_resp)', httpStatus: 200 }

  @ECommerce_2.0_min_tag6
  Scenario: Validating risk signal data as null with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_null_risk_signal_data_req)', response: '#(responses.ecommerce_null_risk_signal_data_error_resp)', httpStatus: 200 }

  @ECommerce_2.0_min_tag7
  Scenario: Validating error scenario for XCommerce with mandatory fields
    * call wfResponse { payload: '#(payloads.ecommerce_invalid_req)', response: '#(responses.ecommerce_invaild_mandatory_fields_resp)', httpStatus: 200 }

  @XCommerce_2.0_tag17
  Scenario: Ecommerce Profile with DECLINE STATUS
    * call wfResponse { payload: '#(payloads.ecommerce_risk_assesment_decline_req)', response: '#(responses.ecommerce_risk_assesment_decline_resp)', httpStatus: 200 }

  @XCommerce_2.0_tag18
  Scenario: Ecommerce Profile with ALLOW STATUS
    * call wfResponse { payload: '#(payloads.ecommerce_risk_assesment_allow_req)', response: '#(responses.ecommerce_risk_assesment_allow_resp)', httpStatus: 200 }

  @XCommerce_2.0_tag19
  Scenario: Ecommerce Profile with challenge low status
    * call wfResponse { payload: '#(payloads.ecommerce_risk_assesment_challenge_low)', response: '#(responses.ecommerce_challenge_low_resp)', httpStatus: 200 }
