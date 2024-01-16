@identity_verification_status_3.0_tag
Feature: Identity Verification Status API integration tests

  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/identity_verification_status/identity_verification_status_3.0_payload.yml')
    * def responses = read('classpath:config/data/responses/identity_verification_status/identity_verification_status_3.0_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * def noWfResponse = read('classpath:features/utilities/one_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=identity_verification_status&policyVersion=3.0'

  @identity_verification_status_3.0_tag1
  Scenario: Missing mandatory attributes
    * call wfResponse { payload: '#(payloads.identity_verification_status_missing_businessUnit_req)', response: '#(responses.identity_verification_status_missing_businessUnit_resp)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.identity_verification_status_missing_authenticationType_req)', response: '#(responses.identity_verification_status_missing_authenticationType_resp)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.identity_verification_status_missing_applicationId_req)', response: '#(responses.identity_verification_status_missing_applicationId_resp)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.identity_verification_status_missing_referenceId_req)', response: '#(responses.identity_verification_status_missing_referenceId_resp)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.identity_verification_status_missing_verificationStatus_and_documentStatus_req)', response: '#(responses.identity_verification_status_missing_verificationStatus_and_documentStatus_resp)', httpStatus: 200 }

  @identity_verification_status_3.0_tag2
  Scenario: CARDFRAUD Business Unit
    * call wfResponse { payload: '#(payloads.identity_verification_status_cardFraud_governmentId_verificationStatus_req)', response: '#(responses.identity_verification_status_cardFraud_governmentId_verificationStatus_resp)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.identity_verification_status_cardFraud_governmentId_documentStatus_req)', response: '#(responses.identity_verification_status_cardFraud_governmentId_documentStatus_resp)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.identity_verification_status_cardFraud_tapToVerify_verificationStatus_req)', response: '#(responses.identity_verification_status_cardFraud_tapToVerify_verificationStatus_resp)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.identity_verification_status_cardFraud_tapToVerify_documentStatus_req)', response: '#(responses.identity_verification_status_cardFraud_tapToVerify_documentStatus_resp)', httpStatus: 200 }
    
  @identity_verification_status_3.0_tag3
  Scenario: WMT Business Unit
    * call wfResponse { payload: '#(payloads.identity_verification_status_wmt_governmentId_verificationStatus_req)', response: '#(responses.identity_verification_status_wmt_governmentId_verificationStatus_resp)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.identity_verification_status_wmt_governmentId_documentStatus_req)', response: '#(responses.identity_verification_status_wmt_governmentId_documentStatus_resp)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.identity_verification_status_wmt_tapToVerify_verificationStatus_req)', response: '#(responses.identity_verification_status_wmt_tapToVerify_verificationStatus_resp)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.identity_verification_status_wmt_tapToVerify_documentStatus_req)', response: '#(responses.identity_verification_status_wmt_tapToVerify_documentStatus_resp)', httpStatus: 200 }
  
  @identity_verification_status_3.0_tag4
  Scenario: 360 Business Unit
    * call wfResponse { payload: '#(payloads.identity_verification_status_360_tapToVerify_verificationStatus_req)', response: '#(responses.identity_verification_status_360_tapToVerify_verificationStatus_resp)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.identity_verification_status_360_tapToVerify_documentStatus_req)', response: '#(responses.identity_verification_status_360_tapToVerify_documentStatus_resp)', httpStatus: 200 }

  @identity_verification_status_3.0_tag5
  Scenario: DEFAULTBU Business Unit
    * call wfResponse { payload: '#(payloads.identity_verification_status_defaultBu_governmentId_verificationStatus_req)', response: '#(responses.identity_verification_status_defaultBu_governmentId_verificationStatus_resp)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.identity_verification_status_defaultBu_governmentId_documentStatus_req)', response: '#(responses.identity_verification_status_defaultBu_governmentId_documentStatus_resp)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.identity_verification_status_defaultBu_tapToVerify_verificationStatus_req)', response: '#(responses.identity_verification_status_defaultBu_tapToVerify_verificationStatus_resp)', httpStatus: 200 }
    * call wfResponse { payload: '#(payloads.identity_verification_status_defaultBu_tapToVerify_documentStatus_req)', response: '#(responses.identity_verification_status_defaultBu_tapToVerify_documentStatus_resp)', httpStatus: 200 }
