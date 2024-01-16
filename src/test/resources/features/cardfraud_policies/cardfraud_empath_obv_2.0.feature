@cardfraud_empath_obv_2.0_tag
Feature: Cardfraud Empath OBV 2.0 Integration Tests

Background:
  * configure headers = req_headers
  * def payloads = read('classpath:config/data/payloads/empath_obv/cardfraud_empath_obv_2.0_payload.yml')
  * def responses = read('classpath:config/data/responses/empath_obv/cardfraud_empath_obv_2.0_response.yml')
  * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
  * def wfResponse = read('classpath:features/utilities/response_step.feature')
  * configure charset = null
  * configure ssl = enableSSL
  * def URL = URL + '?policyName=cardfraud_empath_obv&policyVersion=2.0'

@cardfraud_empath_obv_2.0_tag1
Scenario: Missing mandatory attributes
  * call wfResponse { payload: '#(payloads.cardfraud_empath_obv_missing_addressLine1_req)', response: '#(responses.cardfraud_empath_obv_missing_addressLine1_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.cardfraud_empath_obv_missing_city_req)', response: '#(responses.cardfraud_empath_obv_missing_city_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.cardfraud_empath_obv_missing_countryCode_req)', response: '#(responses.cardfraud_empath_obv_missing_countryCode_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.cardfraud_empath_obv_missing_firstName_req)', response: '#(responses.cardfraud_empath_obv_missing_firstName_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.cardfraud_empath_obv_missing_lastName_req)', response: '#(responses.cardfraud_empath_obv_missing_lastName_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.cardfraud_empath_obv_missing_postalCode_req)', response: '#(responses.cardfraud_empath_obv_missing_postalCode_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.cardfraud_empath_obv_missing_stateCode_req)', response: '#(responses.cardfraud_empath_obv_missing_stateCode_resp)', httpStatus: 200 }

@cardfraud_empath_obv_2.0_tag2
Scenario: Unsupported values for enum and pattern checks
  * call wfResponse { payload: '#(payloads.cardfraud_empath_obv_unsupported_countryCode_value_req)', response: '#(responses.cardfraud_empath_obv_unsupported_countryCode_value_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.cardfraud_empath_obv_unsupported_mobilePhoneNumber_value_req)', response: '#(responses.cardfraud_empath_obv_unsupported_mobilePhoneNumber_value_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.cardfraud_empath_obv_unsupported_postalCode_value_req)', response: '#(responses.cardfraud_empath_obv_unsupported_postalCode_value_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.cardfraud_empath_obv_unsupported_stateCode_value_req)', response: '#(responses.cardfraud_empath_obv_unsupported_stateCode_value_resp)', httpStatus: 200 }

@cardfraud_empath_obv_2.0_tag3
Scenario: Success scenario
  * call wfResponse { payload: '#(payloads.cardfraud_empath_obv_success_req)', response: '#(responses.cardfraud_empath_obv_success_resp)', httpStatus: 200 }
