@p2p_tag
Feature: P2P Component Tests

  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/mb_2_0_p2p/mb_2_0_p2p_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/mb_2_0_p2p/mb_2_0_p2p_1.0_response.yml')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * configure readTimeout = 35000
    * def URL = URL + '?policyName=mb_2_0_p2p_a&policyVersion=1.14'

  Scenario: Validate Masterbuilder API throws error when invoking P2P Component with unknown PIP
    * call wfResponse { payload: '#(payloads.mb_2_0_p2p_req)', response: '#(responses.mb_2_0_p2p_1dot14_resp)', httpStatus: 200 }
