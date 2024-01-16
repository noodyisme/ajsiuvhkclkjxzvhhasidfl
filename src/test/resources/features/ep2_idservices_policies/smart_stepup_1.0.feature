@smart_stepup_1.0_tag
Feature: Smart Stepup Integration Tests

Background:
  # Overwrite default 127.0.0.1 value for Customer-IP-Address header
  * set req_headers['Customer-IP-Address'] = '104.1.232.254'
  * configure headers = req_headers
  * def payloads = read('classpath:config/data/payloads/smart_stepup/smart_stepup_1.0_payload.yml')
  * def responses = read('classpath:config/data/responses/smart_stepup/smart_stepup_1.0_response.yml')
  * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
  * def wfResponse = read('classpath:features/utilities/response_step.feature')
  * configure charset = null
  * configure ssl = enableSSL
  * def URL = URL + '?policyName=smart_stepup&policyVersion=1.0'

@smart_stepup_1.0_tag1
Scenario: Missing mandatory attributes
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_authToken_req)', response: '#(responses.smart_stepup_missing_authToken_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_domain_req)', response: '#(responses.smart_stepup_missing_domain_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_eventName_req)', response: '#(responses.smart_stepup_missing_eventName_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_referenceId_req)', response: '#(responses.smart_stepup_missing_referenceId_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_referenceIdType_req)', response: '#(responses.smart_stepup_missing_referenceIdType_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_riskAssessment_req)', response: '#(responses.smart_stepup_missing_riskAssessment_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_riskAssessment_fields_req)', response: '#(responses.smart_stepup_missing_riskAssessment_fields_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_riskAssessment_web_fields_req)', response: '#(responses.smart_stepup_missing_riskAssessment_web_fields_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_riskAssessment_web_userCookie_req1)', response: '#(responses.smart_stepup_missing_riskAssessment_web_userCookie_resp1)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_riskAssessment_web_userCookie_req2)', response: '#(responses.smart_stepup_missing_riskAssessment_web_userCookie_resp2)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_riskAssessment_web_sessionId_req1)', response: '#(responses.smart_stepup_missing_riskAssessment_web_sessionId_resp1)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_riskAssessment_web_sessionId_req2)', response: '#(responses.smart_stepup_missing_riskAssessment_web_sessionId_resp2)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_riskAssessment_web_deviceFingerPrint_browserFingerprint_req)', response: '#(responses.smart_stepup_missing_riskAssessment_web_deviceFingerPrint_browserFingerprint_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_riskAssessment_mobile_fields_req)', response: '#(responses.smart_stepup_missing_riskAssessment_mobile_fields_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_riskAssessment_mobile_mobileSdkInfo_req)', response: '#(responses.smart_stepup_missing_riskAssessment_mobile_mobileSdkInfo_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_riskAssessment_mobile_deviceIdentifier_req)', response: '#(responses.smart_stepup_missing_riskAssessment_mobile_deviceIdentifier_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_riskAssessment_partnerSignals_fields_req)', response: '#(responses.smart_stepup_missing_riskAssessment_partnerSignals_fields_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_riskAssessment_partnerSignals_riskSignalData_req)', response: '#(responses.smart_stepup_missing_riskAssessment_partnerSignals_riskSignalData_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_missing_riskAssessment_partnerSignals_riskSignalSource_req)', response: '#(responses.smart_stepup_missing_riskAssessment_partnerSignals_riskSignalSource_resp)', httpStatus: 200 }

@smart_stepup_1.0_tag2
Scenario: Unsupported values for enum checks
  * call wfResponse { payload: '#(payloads.smart_stepup_unsupported_domain_value_req)', response: '#(responses.smart_stepup_unsupported_domain_value_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_unsupported_eventName_value_req)', response: '#(responses.smart_stepup_unsupported_eventName_value_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_unsupported_partnerName_value_req)', response: '#(responses.smart_stepup_unsupported_partnerName_value_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_unsupported_referenceIdType_value_req)', response: '#(responses.smart_stepup_unsupported_referenceIdType_value_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_unsupported_subDomain_value_req)', response: '#(responses.smart_stepup_unsupported_subDomain_value_resp)', httpStatus: 200 }

@smart_stepup_1.0_tag3
Scenario: Success scenarios
  * call wfResponse { payload: '#(payloads.smart_stepup_riskAssessment_web_success_req1)', response: '#(responses.smart_stepup_challenge_success_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_riskAssessment_web_success_req2)', response: '#(responses.smart_stepup_challenge_success_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_riskAssessment_mobile_success_req)', response: '#(responses.smart_stepup_challenge_success_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.smart_stepup_riskAssessment_partnerSignals_success_req)', response: '#(responses.smart_stepup_challenge_success_resp)', httpStatus: 200 }
