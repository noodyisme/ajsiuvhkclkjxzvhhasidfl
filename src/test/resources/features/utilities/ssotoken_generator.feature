@ignore
Feature: Generate SSO token on the fly

  Background:
    * def request_headers_payload = read('classpath:config/data/payloads/headers.yml')
    * def current_header = request_headers_payload.sso_token_headers
    # TO be configured
    * def ssoURL = 'https://ssotokenapi-ite.clouddqt.capitalone.com/sso-token-web/private/6673/identity/sso/token?action=create'
    * configure headers = current_header
    * configure charset = null
    * configure ssl = enableSSL
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def payloads = read('classpath:config/data/payloads/ssotoken_generator.yml')

  Scenario: Generate the token
    Given url ssoURL
    * print 'SSO token generator URL', ssoURL
    Given request payloads.sso_token_generator_req
    * retry until response.processStatus != 429  && response.processStatus != 500
    When method post
        # Print out the actual and expected values
    * print 'Response status', responseStatus
    * print 'Generated Token response', response
