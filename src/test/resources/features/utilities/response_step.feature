@ignore
Feature: Masterbuilder invoke policy step with workflow response validation

    Background:
        * configure headers = req_headers
        * configure charset = null
        * configure ssl = enableSSL
        * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
        * def input = { payload: '#(payload)', response: '#(response)', workflowResponse: '#(workflowResponse)', httpStatus: '#(httpStatus)' }

    Scenario: Initiate a policy and check the response
        Given url URL
        # Write out the request and invoke MB to start the policy.
        * print 'Master builder API URL is', URL
        * print 'Policy step payload', input.payload
        Given request input.payload
        * retry until response.processStatus != 429  && response.processStatus != 500
        When method post
        # Print out the actual and expected values
        * print 'Response status', responseStatus
        * print 'Expected status', input.httpStatus
        * print 'Policy response', response
        * print 'Expected response', input.response

        # Assert that the responses are correct
        Then assert responseStatus == input.httpStatus
        And match response == input.response
