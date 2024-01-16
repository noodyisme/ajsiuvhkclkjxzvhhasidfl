@version_forwarding_tag
Feature: This feature is used to test the version forwarder service feature of the identity policy core

  Background:
  # Overwrite default 127.0.0.1 value for Customer-IP-Address header
    * configure headers = req_headers
    * def payload = {name: 'mb_2_0_regression_version_forwarding'}
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=mb_2_0_regression_version_forwarder&'

  @version_forwarding_version1_tag1
  Scenario: Version provided is a whole number, which gets routed to the latest version (Input : 1 , Result : 1.2)
    * def URL = URL + 'policyVersion=1'
    Given url URL
    And request payload
    When method post
    Then match responseStatus == 200
    Then match response.metadata.policyVersion == "1.2"

  @version_forwarding_version1_tag2
  Scenario: Version provided is specific and hence no version forwarding is enabled
    * def URL = URL + 'policyVersion=1.1'
    Given url URL
    And request payload
    When method post
    Then match responseStatus == 200
    Then match response.metadata.policyVersion == "1.1"

  @version_forwarding_version1_tag3
  Scenario: Version provided is specific and hence no version forwarding is enabled for version 1.0
    * def URL = URL + 'policyVersion=1.0'
    Given url URL
    And request payload
    When method post
    Then match responseStatus == 200
    Then match response.metadata.policyVersion == "1.0"

  @version_forwarding_version1_tag4
  Scenario: Version provided is a whole number, which gets routed to the latest version (Input : 1 , Result : 1.2) , followed by step 2 of a multi step policy which also gets routed to the same version
    * def URL = URL + 'policyVersion=1'
    Given url URL
    And request payload
    When method post
    Then match responseStatus == 200
    Then match response.metadata.policyVersion == "1.2"
    * def policyProcessId = response.metadata.policyProcessId
    * def baseURL = URL.slice(0, URL.indexOf('initiate-policy'))
    * def CONTINUEURL = baseURL + 'policy-processes/' + policyProcessId + '/continue-process' + "?step=step2"
#   Call step 2
    Given url CONTINUEURL
    And request payload
    When method post
    Then match responseStatus == 200
    And match response.policyStatus == 'SUCCESS'

  @version_forwarding_version1_tag5
  Scenario: Version provided is only a minor version .0
    * def URL = URL + 'policyVersion=.0'
    Given url URL
    And request payload
    When method post
    Then match responseStatus == 404
    Then match response.developerText == 'Requested resource not found'