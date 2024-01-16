@ignore
Feature: Masterbuilder one step check full response

    Background:
        * configure headers = req_headers
        * configure charset = null
        * configure ssl = enableSSL
        * def input = { payload: '#(payload)', response: '#(response)', httpStatus: '#(httpStatus)' }

    Scenario: Run one step and check full response
        Given url URL
        * print 'Master builder API url is', URL
        * def payload = input.payload
        * print 'payload', payload
        Given request payload
        When method post
        * print 'my response', response
        * def res = input.response
        * print 'expected response', res
        Then match response == res
        * print 'response status', responseStatus
        * print 'httpStatus', input.httpStatus
        And match responseStatus == input.httpStatus


