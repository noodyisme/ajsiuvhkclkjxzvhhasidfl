@ignore
Feature: Masterbuilder custom headers request

    Background:
        * configure charset = null
        * configure ssl = enableSSL
        * def input = { headers: '#(headers)', payload: '#(payload)', response: '#(response)', httpStatus: '#(httpStatus)' }

    Scenario: Run one step and check full response
    	* configure headers = input.headers
        Given url URL
        * print 'Input headers: ', input.headers
        * print 'Masterbuilder API url is', URL
        * def payload = input.payload
        * print 'Payload: ', payload
        Given request payload
        When method post
        * print 'Actual response: ', response
        * def res = input.response
        * print 'Expected response: ', res
        Then match response == res
        * print 'Expected httpStatus: ', responseStatus
        * print 'Actual httpStatus: ', input.httpStatus
        And assert responseStatus == input.httpStatus
