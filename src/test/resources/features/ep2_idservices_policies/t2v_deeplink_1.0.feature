@t2v_deeplink_1.0_tag
Feature: T2V Deeplink Integration Tests

Background:
  * configure headers = req_headers
  * def payloads = read('classpath:config/data/payloads/t2v_deeplink/t2v_deeplink_1.0_payload.yml')
  * def responses = read('classpath:config/data/responses/t2v_deeplink/t2v_deeplink_1.0_response.yml')
  * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
  * def wfResponse = read('classpath:features/utilities/response_step.feature')
  * configure charset = null
  * configure ssl = enableSSL
  * def URL = URL + '?policyName=t2v_deeplink&policyVersion=1.0'
  # sleep function definition taken from https://github.com/intuit/karate#commonly-needed-utilities
  * def sleep = function(ms) { java.lang.Thread.sleep(ms) }

@t2v_deeplink_1.0_tag1
Scenario: Missing mandatory attributes
  * call wfResponse { payload: '#(payloads.t2v_deeplink_missing_applicationId_req)', response: '#(responses.t2v_deeplink_missing_applicationId_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.t2v_deeplink_missing_businessUnit_req)', response: '#(responses.t2v_deeplink_missing_businessUnit_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.t2v_deeplink_missing_model_req)', response: '#(responses.t2v_deeplink_missing_model_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.t2v_deeplink_missing_copyText_req)', response: '#(responses.t2v_deeplink_missing_copyText_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.t2v_deeplink_missing_linkExpiryTimestamp_req)', response: '#(responses.t2v_deeplink_missing_linkExpiryTimestamp_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.t2v_deeplink_missing_keepAliveTimestamp_req)', response: '#(responses.t2v_deeplink_missing_keepAliveTimestamp_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.t2v_deeplink_missing_notificationText_req)', response: '#(responses.t2v_deeplink_missing_notificationText_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.t2v_deeplink_missing_notificationChannel_req)', response: '#(responses.t2v_deeplink_missing_notificationChannel_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.t2v_deeplink_missing_phoneNumberItems_req)', response: '#(responses.t2v_deeplink_missing_phoneNumberItems_resp)', httpStatus: 200 }
  * call wfResponse { payload: '#(payloads.t2v_deeplink_missing_redirectionDetails_req)', response: '#(responses.t2v_deeplink_missing_redirectionDetails_resp)', httpStatus: 200 }

@t2v_deeplink_1.0_tag2
Scenario: Happy Path 1 - verificationStatus == PROCESSED, appendCookie: SUCCESS, cookie?: Yes, redirectUrl: successUrl
  # Call Step 1
  * def step1Response = call wfResponse { payload: '#(payloads.t2v_deeplink_happy_or_unhappy_path_1_step_1_req)', response: '#(responses.default_step1_success_resp)', httpStatus: 200 }
  * def verificationId = step1Response.response.policyResponseBody.verificationId
  # Sleep for 3 seconds
  * sleep(3000)
  # Set verificationStatus to STARTED
  * def verificationStatusResponse = call read('classpath:features/utilities/interactive_identity_verification.feature@interactive_identity_verification_tag1') { verificationId: '#(verificationId)' }
  * assert verificationStatusResponse.verificationStatus == 'STARTED'
  # Sleep for 3 seconds
  * sleep(3000)
  # Get t2vUUID
  * def t2vUuidResponse = call read('classpath:features/utilities/interactive_identity_verification.feature@interactive_identity_verification_tag2') { verificationId: '#(verificationId)' }
  * def t2vUuid = t2vUuidResponse.t2vUuid
  # Set verificationStatus to PROCESSED
  * def verificationStatusResponse = call read('classpath:features/utilities/interactive_identity_verification.feature@interactive_identity_verification_tag3') { t2vUuid: '#(t2vUuid)' }
  * assert verificationStatusResponse.verificationStatus == 'PROCESSED'
  # Sleep for 3 seconds
  * sleep(3000)
  # Set URL for Step 2
  * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
  * def URL = baseURL + 'policy-processes/' + step1Response.response.metadata.policyProcessId + '/continue-process'
  # Call Step 2
  * call wfResponse { payload: {}, response: '#(responses.cookie_and_success_url_resp)', httpStatus: 200 }

@t2v_deeplink_1.0_tag3
Scenario: Happy Path 2 - verificationStatus == PROCESSED, appendCookie: BOTH, cookie?: Yes, redirectUrl: successUrl
  # Call Step 1
  * def step1Response = call wfResponse { payload: '#(payloads.t2v_deeplink_happy_or_unhappy_path_2_step_1_req)', response: '#(responses.default_step1_success_resp)', httpStatus: 200 }
  * def verificationId = step1Response.response.policyResponseBody.verificationId
  # Sleep for 3 seconds
  * sleep(3000)
  # Set verificationStatus to STARTED
  * def verificationStatusResponse = call read('classpath:features/utilities/interactive_identity_verification.feature@interactive_identity_verification_tag1') { verificationId: '#(verificationId)' }
  * assert verificationStatusResponse.verificationStatus == 'STARTED'
  # Sleep for 3 seconds
  * sleep(3000)
  # Get t2vUUID
  * def t2vUuidResponse = call read('classpath:features/utilities/interactive_identity_verification.feature@interactive_identity_verification_tag2') { verificationId: '#(verificationId)' }
  * def t2vUuid = t2vUuidResponse.t2vUuid
  # Set verificationStatus to PROCESSED
  * def verificationStatusResponse = call read('classpath:features/utilities/interactive_identity_verification.feature@interactive_identity_verification_tag3') { t2vUuid: '#(t2vUuid)' }
  * assert verificationStatusResponse.verificationStatus == 'PROCESSED'
  # Sleep for 3 seconds
  * sleep(3000)
  # Set URL for Step 2
  * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
  * def URL = baseURL + 'policy-processes/' + step1Response.response.metadata.policyProcessId + '/continue-process'
  # Call Step 2
  * call wfResponse { payload: {}, response: '#(responses.cookie_and_success_url_resp)', httpStatus: 200 }

@t2v_deeplink_1.0_tag4
Scenario: Happy Path 3 - verificationStatus == PROCESSED, appendCookie: FAILURE, cookie?: No, redirectUrl: successUrl
  # Call Step 1
  * def step1Response = call wfResponse { payload: '#(payloads.t2v_deeplink_happy_or_unhappy_path_3_step_1_req)', response: '#(responses.default_step1_success_resp)', httpStatus: 200 }
  * def verificationId = step1Response.response.policyResponseBody.verificationId
  # Sleep for 3 seconds
  * sleep(3000)
  # Set verificationStatus to STARTED
  * def verificationStatusResponse = call read('classpath:features/utilities/interactive_identity_verification.feature@interactive_identity_verification_tag1') { verificationId: '#(verificationId)' }
  * assert verificationStatusResponse.verificationStatus == 'STARTED'
  # Sleep for 3 seconds
  * sleep(3000)
  # Get t2vUUID
  * def t2vUuidResponse = call read('classpath:features/utilities/interactive_identity_verification.feature@interactive_identity_verification_tag2') { verificationId: '#(verificationId)' }
  * def t2vUuid = t2vUuidResponse.t2vUuid
  # Set verificationStatus to PROCESSED
  * def verificationStatusResponse = call read('classpath:features/utilities/interactive_identity_verification.feature@interactive_identity_verification_tag3') { t2vUuid: '#(t2vUuid)' }
  * assert verificationStatusResponse.verificationStatus == 'PROCESSED'
  # Sleep for 3 seconds
  * sleep(3000)
  # Set URL for Step 2
  * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
  * def URL = baseURL + 'policy-processes/' + step1Response.response.metadata.policyProcessId + '/continue-process'
  # Call Step 2
  * call wfResponse { payload: {}, response: '#(responses.no_cookie_and_success_url_resp)', httpStatus: 200 }

@t2v_deeplink_1.0_tag5
Scenario: Unhappy Path 1 - verificationStatus != PROCESSED, appendCookie: SUCCESS, cookie?: No, redirectUrl: failureUrl
  # Call Step 1
  * def step1Response = call wfResponse { payload: '#(payloads.t2v_deeplink_happy_or_unhappy_path_1_step_1_req)', response: '#(responses.default_step1_success_resp)', httpStatus: 200 }
  # Sleep for 3 seconds
  * sleep(3000)
  # Set URL for Step 2
  * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
  * def URL = baseURL + 'policy-processes/' + step1Response.response.metadata.policyProcessId + '/continue-process'
  # Call Step 2
  * call wfResponse { payload: {}, response: '#(responses.no_cookie_and_failure_url_resp)', httpStatus: 200 }

@t2v_deeplink_1.0_tag6
Scenario: Unhappy Path 2 - verificationStatus != PROCESSED, appendCookie: BOTH, cookie?: Yes, redirectUrl: failureUrl
  # Call Step 1
  * def step1Response = call wfResponse { payload: '#(payloads.t2v_deeplink_happy_or_unhappy_path_2_step_1_req)', response: '#(responses.default_step1_success_resp)', httpStatus: 200 }
  # Sleep for 3 seconds
  * sleep(3000)
  # Set URL for Step 2
  * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
  * def URL = baseURL + 'policy-processes/' + step1Response.response.metadata.policyProcessId + '/continue-process'
  # Call Step 2
  * call wfResponse { payload: {}, response: '#(responses.cookie_and_failure_url_resp)', httpStatus: 200 }

@t2v_deeplink_1.0_tag7
Scenario: Unhappy Path 3 - verificationStatus != PROCESSED, appendCookie: FAILURE, cookie?: Yes, redirectUrl: failureUrl
  # Call Step 1
  * def step1Response = call wfResponse { payload: '#(payloads.t2v_deeplink_happy_or_unhappy_path_3_step_1_req)', response: '#(responses.default_step1_success_resp)', httpStatus: 200 }
  # Sleep for 3 seconds
  * sleep(3000)
  # Set URL for Step 2
  * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
  * def URL = baseURL + 'policy-processes/' + step1Response.response.metadata.policyProcessId + '/continue-process'
  # Call Step 2
  * call wfResponse { payload: {}, response: '#(responses.cookie_and_failure_url_resp)', httpStatus: 200 }

# NOTE: this scenario is not intended to run against local. If attempting to run this entire feature file against local, uncomment the @ignore tag and comment
#  out the @t2v_deeplink_1.0_tag8 tag
#@ignore
@t2v_deeplink_1.0_tag8
Scenario: Happy Path 1 (calling DCRP-OL instead of Step 2) - verificationStatus == PROCESSED, appendCookie: SUCCESS, cookie?: Yes (but only in header), redirectUrl: successUrl
  # Call Step 1
  * def step1Response = call wfResponse { payload: '#(payloads.t2v_deeplink_happy_or_unhappy_path_1_step_1_req)', response: '#(responses.default_step1_success_resp)', httpStatus: 200 }
  * def verificationId = step1Response.response.policyResponseBody.verificationId
  # Sleep for 3 seconds
  * sleep(3000)
  # Set verificationStatus to STARTED
  * def verificationStatusResponse = call read('classpath:features/utilities/interactive_identity_verification.feature@interactive_identity_verification_tag1') { verificationId: '#(verificationId)' }
  * assert verificationStatusResponse.verificationStatus == 'STARTED'
  # Sleep for 3 seconds
  * sleep(3000)
  # Get t2vUUID
  * def t2vUuidResponse = call read('classpath:features/utilities/interactive_identity_verification.feature@interactive_identity_verification_tag2') { verificationId: '#(verificationId)' }
  * def t2vUuid = t2vUuidResponse.t2vUuid
  # Set verificationStatus to PROCESSED
  * def verificationStatusResponse = call read('classpath:features/utilities/interactive_identity_verification.feature@interactive_identity_verification_tag3') { t2vUuid: '#(t2vUuid)' }
  * assert verificationStatusResponse.verificationStatus == 'PROCESSED'
  # Sleep for 3 seconds
  * sleep(3000)
  # Call DCRP-OL
  * def dcrpOlResponse = call read('classpath:features/utilities/dcrp_ol.feature') { policyProcessId: '#(step1Response.response.metadata.policyProcessId)' }
  * match dcrpOlResponse.response == responses.no_cookie_and_success_url_resp
  * match dcrpOlResponse.setCookieResponseHeader contains responses.dcrp_ol_set_cookie_response_header_value

# NOTE: this scenario is not intended to run against local. If attempting to run this entire feature file against local, uncomment the @ignore tag and comment
#  out the @t2v_deeplink_1.0_tag9 tag
#@ignore
@t2v_deeplink_1.0_tag9
Scenario: Unhappy Path 1 (calling DCRP-OL instead of Step 2) - verificationStatus != PROCESSED, appendCookie: SUCCESS, cookie?: No, redirectUrl: failureUrl
  # Call Step 1
  * def step1Response = call wfResponse { payload: '#(payloads.t2v_deeplink_happy_or_unhappy_path_1_step_1_req)', response: '#(responses.default_step1_success_resp)', httpStatus: 200 }
  # Sleep for 3 seconds
  * sleep(3000)
  # Call DCRP-OL
  * def dcrpOlResponse = call read('classpath:features/utilities/dcrp_ol.feature') { policyProcessId: '#(step1Response.response.metadata.policyProcessId)' }
  * match dcrpOlResponse.response == responses.no_cookie_and_failure_url_resp
  * match dcrpOlResponse.setCookieResponseHeader !contains responses.dcrp_ol_set_cookie_response_header_value
