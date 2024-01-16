@ECommerce_2.0_tag
Feature: Policy Process Continue 2.0 integration tests

 ##change the folder and file name of steps to ecommerce from xcommerce
 ########################### defining requests and responses
  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/ecommerce/continue_policy_process_payload.yml')
    * def responses = read('classpath:config/data/responses/ecommerce/continue_policy_process_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * def noWfResponse = read('classpath:features/utilities/one_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=ecommerce_step_up&policyVersion=2.0'
    * copy reqHeadersCopy = req_headers
    * def AuthToken = karate.callSingle('classpath:features/callOnce.feature')
    * def oauth = AuthToken != ""?'Bearer '+ AuthToken.response.access_token:""
            #################### URL's ################################
    * def ResetPinURL = 'https://api-it.cloud.capitalone.com/identity/profiles/reset-pin-count'
    * def LockAPIURL = 'https://api-it.cloud.capitalone.com/identity/profile/lock'
################### ProfileReferenceID's ################################
    * def PRID1 = '+21Jtv4HNuCcPqshEqtkk+OHlp1JeO9DaXsBYYxzq6zx+UYY4zggPGhwRUOmrgQS'

     ###################### Positive Scenario #########################

         ######################################## Headers ################################
    * def ResetPinHeaders =
    """
    {
   "Api-Key": "RTM",
   "Content-Type": "application/json",
   "client-ip": "127.0.0.1",
   "Accept": "application/json;v=3"
    }
    """


  @RESET
  Scenario Outline: Reset Pin Count
    #making Reset Pin call to Reset User Pin Limit
    Given url ResetPinURL
    And headers ResetPinHeaders
    And header authorization = oauth
    And header profileReferenceId = '<PRID>'
    And request {"processIdentificationToken": "SECAUTH_Google_Autofill"}
    When method post
    * print 'ResetPin Response', response
    Examples:
      | PRID                                                                                                         |
      | rd5GDeD6/Mn9JOBYuktgkLzXP3Lw5Yz1QlVnnTmJ39VNOm721+et/9K4bhHRuLyufPJ10P090zzEELbOgY60Mlvk6fq/RpCDOpZoIb84HmA= |
      | rd5GDeD6/Mn9JOBYuktgkLzXP3Lw5Yz1QlVnnTmJ39Ud1g7avvWkOz8U5sYDvtynsx/I3zCyZBuDGE8dKbQaoNY4m9v6NkwGsqjgYxSeJYA= |
      | rd5GDeD6/Mn9JOBYuktgkLzXP3Lw5Yz1QlVnnTmJ39VofPeALKXogcskDwMoP1JGL9wxCZYJ5GFokhVvWiy3NYhx7kfz8rJuID7fMb1smdg= |
      | rd5GDeD6/Mn9JOBYuktgkLzXP3Lw5Yz1QlVnnTmJ39Vxl8FawXpB4kv+L/9gAODhfKM+n+bC443zYcEFT3+dYkQT8961itISbKx8yKiZMLs= |
      | rd5GDeD6/Mn9JOBYuktgkLzXP3Lw5Yz1QlVnnTmJ39WtzMxhlQ2NHwscOFtFYM4vpEzsTrLbScg9Dr/whGcve2WVuycfTqwYM/GBBkXcXIg= |
      | rd5GDeD6/Mn9JOBYuktgkLzXP3Lw5Yz1QlVnnTmJ39U1n193oMx+ew+aejFbHqCQli8l99nolMoIMohwHbc5ASuMoMvBATzmnwPSc64cwFE= |
      | rd5GDeD6/Mn9JOBYuktgkLzXP3Lw5Yz1QlVnnTmJ39Xcj2WElgvwQBDdESnYZGAzzPqm5vVxi8sB6xYl09HmI37Ix4ABc4vp53BexsN9NIs= |
      | rd5GDeD6/Mn9JOBYuktgkLzXP3Lw5Yz1QlVnnTmJ39WuznFQa5y29S/HF+1LXfaSSrauz8wpFjQ7QYaKCxnMh2hwTPj7nCheZahZOaGirE4= |
      | rd5GDeD6/Mn9JOBYuktgkLzXP3Lw5Yz1QlVnnTmJ39U/g32HRuHKTpzHgyRqpVlwR+Gm0RRrPcGNCZjhq0QR3g9JKVwRuALbv04SIqpKrYg= |
      | rd5GDeD6/Mn9JOBYuktgkLzXP3Lw5Yz1QlVnnTmJ39WGfjMTi0iSS2WBT6S0MYmVAvGltNI/FcaKK7OksKZ7gWHyVzhSvFo306R34BYvPso= |
      | +21Jtv4HNuCcPqshEqtkk+OHlp1JeO9DaXsBYYxzq6zx+UYY4zggPGhwRUOmrgQS                                             |


  @policy_process_continue_tag1
  Scenario: Validating Success scenario for Policy Process Continue with mandatory fields
    * call wfResponse { payload: '#(payloads.ecommerce_successfull_req)', response: '#(responses.ecommerce_successfull_resp)', httpStatus: 200 }
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
    * def URL = baseURL + 'policy-processes/' + response.metadata.policyProcessId + '/continue-process?step=four_confirm_challenge'
    * call wfResponse { payload: '#(payloads.policy_process_successfull_req)', response: '#(responses.continue_policy_process_successfull_resp)', httpStatus: 200 }


     ###################### Error Scenarios #########################
  @policy_process_continue_tag2
  Scenario: Validating Success scenario for Policy Process Continue with mandatory fields
    * call wfResponse { payload: '#(payloads.ecommerce_successfull_req)', response: '#(responses.ecommerce_successfull_resp)', httpStatus: 200 }
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
    * def URL = baseURL + 'policy-processes/' + response.metadata.policyProcessId + '0/continue-process'
    * call wfResponse { payload: '#(payloads.policy_process_successfull_req)', response: '#(responses.continue_policy_process_error_resp)', httpStatus: 404 }

  @policy_process_continue_tag3
  Scenario: Validating Success scenario for Continue Policy Process with mandatory fields
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
    * def URL = baseURL + 'policy-processes/'
    * call wfResponse { payload: '#(payloads.policy_process_successfull_req)', response: '#(responses.continue_policy_process_404_error_resp)', httpStatus: 404 }


  @policy_process_continue_tag4
  Scenario: Validating http 403 error scenario for Continue Policy Process

    * set reqHeadersCopy.Api-Key = 'SYSTEM'
    * configure headers = reqHeadersCopy
    * print 'Calling initiate policy validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.continue_policy_process_403_error_resp
    * print 'responsejson:', responsejson
    Given url URL
    When method get
    Then match responseStatus == 403
    * print 'Interactive get policy definitions API (first endpoint) response:', response
    Then match response == responsejson

  @policy_process_continue_tag5
  Scenario: Validating http 405 error scenario for Continue Policy Process
    * print 'Calling initiate policy validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.continue_policy_process_405_error_resp
    * print 'responsejson:', responsejson
    Given url URL
    When method get
    Then match responseStatus == 405
    * print 'Interactive get policy definitions API (first endpoint) response:', response
    Then match response == responsejson

  @policy_process_continue_tag6
  Scenario: Validating http 406 error scenario for Continue Policy Process
    * set reqHeadersCopy.Api-Key = 'MOBILE'
    * set reqHeadersCopy.Accept = 'application/xml;v=1'
    * configure headers = reqHeadersCopy
    * print 'GET headers is:', headers
    * print 'Calling initiate policy validation API (second URL)'
    * print 'GET url is:', URL
    * def responsejson = responses.continue_policy_process_406_error_resp
    * print 'responsejson:', responsejson
    Given url URL
    And request payloads.ecommerce_successfull_req
    When method POST
    Then match responseStatus == 406
    * print 'Interactive get policy definitions API (first endpoint) response:', response
    Then match response == responsejson

         ###################### Step2 Scenarios #########################
  @policy_process_continue_tag7
  Scenario: Validating Success scenario for Step2 - two_initiate_challenge
    * call wfResponse { payload: '#(payloads.ecommerce_step1_req)', response: '#(responses.ecommerce_successfull_resp)', httpStatus: 200 }
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
        ###Invoking the two_initiate_challenge
    * def URL = baseURL + 'policy-processes/' + response.metadata.policyProcessId + '/continue-process?step=two_initiate_challenge'
    * call wfResponse { payload: '#(payloads.ecommerce_step2_successfull_req)', response: '#(responses.ecommerce_step2_successfull_resp)', httpStatus: 200 }


  @policy_process_continue_tag8
  Scenario: Step 3- three_validate_challenge should not execute before step 2 -two_initiate_challenge
    * call wfResponse { payload: '#(payloads.ecommerce_successfull_req)', response: '#(responses.ecommerce_successfull_resp)', httpStatus: 200 }
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
    ### Invoking the three_validate_challenge
    * def URL = baseURL + 'policy-processes/' + response.metadata.policyProcessId + '/continue-process?step=three_validate_challenge'
    * call wfResponse { payload: '#(payloads.ecommerce_step3_successfull_req)', response: '#(responses.ecommerce_step3_executed_before_step2_resp)', httpStatus: 404 }

  @policy_process_continue_tag9
  Scenario: Step 3- two_initiate_challenge should not be allowed for GOOGLEPLATFORMAUTH
    * call wfResponse { payload: '#(payloads.ecommerce_risk_assesment_challenge_low)', response: '#(responses.ecommerce_challenge_low_resp)', httpStatus: 200 }
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
    ### Invoking the two_initiate_challenge
    * def URL = baseURL + 'policy-processes/' + response.metadata.policyProcessId + '/continue-process?step=two_initiate_challenge'
    * call wfResponse { payload: '#(payloads.ecommerce_step2_successfull_req)', response: '#(responses.ecommerce_step2_not_allowed_platdformauth_resp)', httpStatus: 404 }

