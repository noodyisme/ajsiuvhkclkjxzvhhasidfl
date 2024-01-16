@p2p_tag
Feature: P2P Component Tests

  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/mb_2_0_p2p/mb_2_0_p2p_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/mb_2_0_p2p/mb_2_0_p2p_1.0_response.yml')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=mb_2_0_p2p_a&policyVersion=1.13'

  Scenario: Validate P2P Component works with Configuration Management
    * set req_headers.business-event = 'ENTERPRISE.TEST.BUSINESS_EVENT.WEB'
    * call wfResponse { payload: '#(payloads.mb_2_0_p2p_req)', response: '#(responses.mb_2_0_p2p_1dot13_resp)', httpStatus: 200 }

  Scenario: Validate P2P Component works with Configuration Management, invalid business event
    * set req_headers.business-event = 'ENTERPRISE.TEST.BUSINESS_EVENT.WEB2'
    * call wfResponse { payload: '#(payloads.mb_2_0_p2p_req)', response: '#(responses.mb_2_0_p2p_1dot13_invalid_resp)', httpStatus: 200 }