@strict_abac_enforcement_tag
Feature: This feature is used to test the strict abac enforcement for a resource requested by a subject

  Background:
  # Overwrite default 127.0.0.1 value for Customer-IP-Address header
    * configure headers = req_headers
    * def payload = {name: 'abac enforcement test sample'}
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=mb_2_0_regression_abac&'
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))

  @strict_abac_enforcement_success_with_valid_subject_tag1
  Scenario: Abac Enforcement successful with valid clientId (Subject) for valid PolicyName and PolicyVersion (Resource) with available Policy Access
    * def URL = URL + 'policyVersion=1.0'
    * copy reqHeadersCopy = req_headers
    * configure headers = reqHeadersCopy
    Given url URL
    And request payload
    When method post
    Then match responseStatus == 200



  @strict_abac_enforcement_success_with_valid_subject_step2_tag1
  Scenario: Abac Enforcement successful with valid clientId (Subject) for valid PolicyName and PolicyVersion (Resource) with available Policy Access - including step 2
    * def URL = URL + 'policyVersion=1.0'
    * copy reqHeadersCopy = req_headers
    * configure headers = reqHeadersCopy
    Given url URL
    And request payload
    When method post
    Then match responseStatus == 200
    * def policyProcessId = response.metadata.policyProcessId
    * def continueUrl = baseURL + 'policy-processes/' + policyProcessId + '/continue-process' + "?step=step2"
    Given url continueUrl
    And request payload
    When method post
    Then match responseStatus == 200
    And match response.policyStatus == 'SUCCESS'

  @strict_abac_enforcement_failure_with_invalid_resource_tag1
  Scenario: Abac Enforcement failure for valid resource with unavailable Policy Access
    * def URL = URL + 'policyVersion=2.0'
    * copy reqHeadersCopy = req_headers
    # Adding a client Id/ Subject to the requested resource
    * set reqHeadersCopy.client_id = '11223345'
    * configure headers = reqHeadersCopy
    Given url URL
    And request payload
    When method post
    Then match responseStatus == 401
    Then match response.id == "401001"
    Then match response.text == "Authorization failed"


  @strict_abac_enforcement_failure_with_invalid_subject_tag1
  Scenario: Abac Enforcement failure with invalid clientId (Subject) for valid PolicyName and PolicyVersion (Resource) with available Policy Access
    * def URL = URL + 'policyVersion=1.0'
    * copy reqHeadersCopy = req_headers
    # Adding a client Id/ Subject to the requested resource
    * set reqHeadersCopy.client_id = '11223345'
    * configure headers = reqHeadersCopy
    Given url URL
    And request payload
    When method post
    Then match responseStatus == 401
    Then match response.id == "401002"
    Then match response.text == "Authorization failed"

  @strict_abac_enforcement_failure_with_invalid_subject_step2_tag1
  Scenario: Abac Enforcement failure with invalid clientId (Subject) for valid PolicyName and PolicyVersion (Resource) with available Policy Access in step 2
    * def URL = URL + 'policyVersion=1.0'
    * copy reqHeadersCopy = req_headers
    * configure headers = reqHeadersCopy
    Given url URL
    And request payload
    When method post
    Then match responseStatus == 200
    * def policyProcessId = response.metadata.policyProcessId
    * def continueUrl = baseURL + 'policy-processes/' + policyProcessId + '/continue-process' + "?step=step2"
    * set reqHeadersCopy.client_id = '11223345'
    Given url continueUrl
    And request payload
    When method post
    Then match responseStatus == 401
    Then match response.id == "401002"
    Then match response.text == "Authorization failed"

  @strict_abac_enforcement_failure_with_denied_subject_tag1
  Scenario: Abac Enforcement failure with denied clientId (Subject) for valid PolicyName and PolicyVersion (Resource) with available Policy Access
    * def URL = URL + 'policyVersion=1.0'
    * copy reqHeadersCopy = req_headers
    # Adding a client Id/ Subject to the requested resource
    * set reqHeadersCopy.client_id = '54332211'
    * configure headers = reqHeadersCopy
    Given url URL
    And request payload
    When method post
    Then match responseStatus == 401
    Then match response.id == "401003"
    Then match response.text == "Authorization failed"


  @strict_abac_enforcement_failure_with_denied_subject_step2_tag1
  Scenario: Abac Enforcement failure with denied clientId (Subject) for valid PolicyName and PolicyVersion (Resource) with available Policy Access in step 2
    * def URL = URL + 'policyVersion=1.0'
    * copy reqHeadersCopy = req_headers
    * configure headers = reqHeadersCopy
    Given url URL
    And request payload
    When method post
    Then match responseStatus == 200
    * def policyProcessId = response.metadata.policyProcessId
    * def continueUrl = baseURL + 'policy-processes/' + policyProcessId + '/continue-process' + "?step=step2"
    * set reqHeadersCopy.client_id = '54332211'
    Given url continueUrl
    And request payload
    When method post
    Then match responseStatus == 401
    Then match response.id == "401003"
    Then match response.text == "Authorization failed"

