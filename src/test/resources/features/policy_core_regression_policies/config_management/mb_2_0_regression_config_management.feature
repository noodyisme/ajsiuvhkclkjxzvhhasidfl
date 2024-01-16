@mb_2_0_regression_config_management_1._0tag
Feature: MB2 Config Management Tests

  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/mb_2_0_regression_config_management/mb_2_0_regression_config_management_1.0_payload.yml')
    * def responses = read('classpath:config/data/responses/mb_2_0_regression_config_management/mb_2_0_regression_config_management_1.0_response.yml')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=mb_2_0_regression_config_management&policyVersion=1.0'

  @mb_2_0_regression_config_management_1._0tag1
  Scenario: No business-event Header
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_config_management_req)', response: '#(responses.mb_2_0_regression_config_management_no_header_resp)', httpStatus: 200 }

  @mb_2_0_regression_config_management_1._0tag2
  Scenario: business-event Header is MOBILE
    * set req_headers.business-event = 'ENTERPRISE.TEST.BUSINESS_EVENT.MOBILE'
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_config_management_req)', response: '#(responses.mb_2_0_regression_config_management_mobile_header_resp)', httpStatus: 200 }

  @mb_2_0_regression_config_management_1._0tag3
  Scenario: business-event Header is WEB
    * set req_headers.business-event = 'ENTERPRISE.TEST.BUSINESS_EVENT.WEB'
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_config_management_req)', response: '#(responses.mb_2_0_regression_config_management_web_header_resp)', httpStatus: 200 }

  @mb_2_0_regression_config_management_1._0tag4
  Scenario: business-event Header is Invalid
    * set req_headers.business-event = 'ENTERPRISE.TEST.BUSINESS_EVENT.ASDF'
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_config_management_req)', response: '#(responses.mb_2_0_regression_config_management_business_event_does_not_exist_resp)', httpStatus: 200 }

  @mb_2_0_regression_config_management_1._0tag5
  Scenario: business-event Header is valid app level, invalid event level
    * set req_headers.business-event = "CYBER.IDB.PLATFORM.POLICY_CORE.COFFEE"
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_config_management_req)', response: '#(responses.mb_2_0_regression_config_management_app_resp)', httpStatus: 200}

  @mb_2_0_regression_config_management_1._0tag6
  Scenario: business-event header valid app level, no event level
    * set req_headers.business-event = "CYBER.IDB.PLATFORM.POLICY_CORE"
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_config_management_req)', response: '#(responses.mb_2_0_regression_config_management_app_resp)', httpStatus: 200}

  @mb_2_0_regression_config_management_1._0tag7
  Scenario: business-event header valid app level, trailing period
    * set req_headers.business-event = "CYBER.IDB.PLATFORM.POLICY_CORE."
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_config_management_req)', response: '#(responses.mb_2_0_regression_config_management_app_resp)', httpStatus: 200}

  @mb_2_0_regression_config_management_1._0tag8
  Scenario: business-event header valid app level, valid event level, trailing period
    * set req_headers.business-event = "CYBER.IDB.PLATFORM.POLICY_CORE.CONFIG."
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_config_management_req)', response: '#(responses.mb_2_0_regression_config_management_business_event_does_not_exist_resp)', httpStatus: 200}

  @mb_2_0_regression_config_management_1._0tag9
  Scenario: business-event header non-existent app level and event level
    * set req_headers.business-event = "CYBER.IDB.PLATFORM.POLICY_POUR.COFFEE"
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_config_management_req)', response: '#(responses.mb_2_0_regression_config_management_business_event_does_not_exist_resp)', httpStatus: 200}

  @mb_2_0_regression_config_management_1._0tag10
  Scenario: business-event header invalid characters
    * set req_headers.business-event = "CYBER.IDB.PLATFORM.POLICY_POUR.C()FF$$#@"
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_config_management_req)', response: '#(responses.mb_2_0_regression_config_management_invalid_or_missing_business_event_resp)', httpStatus: 400}

  @mb_2_0_regression_config_management_1._0tag11
  Scenario: business-event header empty
    * set req_headers.business-event = ""
    * call wfResponse { payload: '#(payloads.mb_2_0_regression_config_management_req)', response: '#(responses.mb_2_0_regression_config_management_invalid_or_missing_business_event_resp)', httpStatus: 400}