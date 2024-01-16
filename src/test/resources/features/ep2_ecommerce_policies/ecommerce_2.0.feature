@ECommerce_2.0_tag
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

     ###################### Positive Scenario #########################

  @XCommerce_2.0_tag1
  Scenario: Validating Success scenario for XCommerce with mandatory fields
    * call wfResponse { payload: '#(payloads.ecommerce_successfull_req)', response: '#(responses.ecommerce_successfull_resp)', httpStatus: 200 }

     ###################### Error Scenarios #########################

  @XCommerce_2.0_tag2
  Scenario: Validating Shared id as null with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_null_shared_id_param_req)', response: '#(responses.ecommerce_shared_id_error_resp)', httpStatus: 200 }


  @XCommerce_2.0_tag3
  Scenario: Validating Vendor id as null with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_null_vendor_id_param_req)', response: '#(responses.ecommerce_vender_id_error_resp)', httpStatus: 200 }

  @XCommerce_2.0_tag4
  Scenario: Validating profile reference id as null with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_null_profile_reference_id_req)', response: '#(responses.ecommerce_profile_reference_id_error_resp)', httpStatus: 200 }

   ## @XCommerce_2.0_tag5
   ##Scenario: Validating account reference id as null with Error scenario in XCommerce
  ##     * call wfResponse { payload: '#(payloads.ecommerce_null_account_reference_id_req)', response: '#(responses.ecommerce_account_reference_id_error_resp)', httpStatus: 200 }

  @XCommerce_2.0_tag5
  Scenario: Validating stage as null with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_null_stage_req)', response: '#(responses.ecommerce_stage_error_resp)', httpStatus: 200 }

  @XCommerce_2.0_tag6
  Scenario: Validating event name as null with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_null_event_name_req)', response: '#(responses.ecommerce_null_event_name_error_resp)', httpStatus: 200 }

  @XCommerce_2.0_tag7
  Scenario: Validating risk signal data as null with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_null_risk_signal_data_req)', response: '#(responses.ecommerce_null_risk_signal_data_error_resp)', httpStatus: 200 }

  @XCommerce_2.0_tag8
  Scenario: Validating Ipaddress as null with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_null_ip_address_req)', response: '#(responses.ecommerce_ip_address_error_resp)', httpStatus: 200 }

  @XCommerce_2.0_tag9
  Scenario: Validating date as null with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_null_date_format_req)', response: '#(responses.ecommerce_null_date_error_resp)', httpStatus: 200 }

  @XCommerce_2.0_tag10
  Scenario: Validating invalid date format with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_invalid_date_value_req)', response: '#(responses.ecommerce_invaild_date_error_resp)', httpStatus: 200 }

  @XCommerce_2.0_tag11
  Scenario: Validating invalid number format with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_invalid_number_value_req)', response: '#(responses.ecommerce_number_format_error_resp)', httpStatus: 200 }

  @XCommerce_2.0_tag12
  Scenario: Validating error scenario for XCommerce with mandatory fields
    * call wfResponse { payload: '#(payloads.ecommerce_invalid_req)', response: '#(responses.ecommerce_invaild_mandatory_fields_resp)', httpStatus: 200 }

  @XCommerce_2.0_tag13
  Scenario: Validating invalid boolean format with Error scenario in XCommerce
    * call wfResponse { payload: '#(payloads.ecommerce_invaild_boolean_req)', response: '#(responses.ecommerce_invaild_boolean_resp)', httpStatus: 200 }

  @XCommerce_2.0_tag14
  Scenario: Validating http 405 error scenario for Policy Definitions with mandatory fields
    * print 'Calling initiate policy validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.ecommerce_http_405_resp
    * print 'responsejson:', responsejson
    Given url URL
    When method get
    Then match responseStatus == 405
    * print 'Interactive get policy definitions API (first endpoint) response:', response
    Then match response == responsejson

  @XCommerce_2.0_tag15
  Scenario: Validating http 406 error scenario for Policy Definitions with mandatory fields
    * set reqHeadersCopy.Api-Key = 'MOBILE'
    * set reqHeadersCopy.Accept = 'application/xml;v=1'
    * configure headers = reqHeadersCopy
    * print 'GET headers is:', headers
    * print 'Calling initiate policy validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.ecommerce_http_406_resp
    * print 'responsejson:', responsejson
    Given url URL
    And request payloads.ecommerce_successfull_req
    When method POST
    Then match responseStatus == 406
    * print 'Interactive get policy definitions API (first endpoint) response:', response
    Then match response == responsejson

  @XCommerce_2.0_tag16
  Scenario: Ecommerce Profile with DECLINE STATUS
    * call wfResponse { payload: '#(payloads.ecommerce_risk_assesment_decline_req)', response: '#(responses.ecommerce_risk_assesment_decline_resp)', httpStatus: 200 }

  @XCommerce_2.0_tag17
  Scenario: Ecommerce Profile with ALLOW STATUS
    * call wfResponse { payload: '#(payloads.ecommerce_risk_assesment_allow_req)', response: '#(responses.ecommerce_risk_assesment_allow_resp)', httpStatus: 200 }

  @XCommerce_2.0_tag18
  Scenario: Ecommerce Profile with challenge low status
    * call wfResponse { payload: '#(payloads.ecommerce_risk_assesment_challenge_low)', response: '#(responses.ecommerce_challenge_low_resp)', httpStatus: 200 }
