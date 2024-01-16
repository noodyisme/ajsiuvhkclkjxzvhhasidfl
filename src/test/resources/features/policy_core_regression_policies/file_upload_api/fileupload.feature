@fileupload_tag
Feature: File upload API

  Background:
    * configure ssl = enableSSL
    * def URL = FILE_UPLOAD_URL
    * print URL
    * def headers =  read('classpath:config/data/payloads/file_upload/file_upload_headers.yml')
    * print headers
    * bytes fileInBytes = read('classpath:config/data/payloads/file_upload/VA_DL_Front.jpeg')
    * def cryptoUtil = Java.type('com.capitalone.identity.identitybuilder.policycore.service.util.CryptoUtil')
    * def jwtKeySetter =
    """
    function() {
        var jwtKey = Java.type('com.capitalone.identity.identitybuilder.policycore.service.util.JWTKey')
        jwtKeyObj = new jwtKey()
        jwtKeyObj.setKid("1729dfc0-210b-4bfb-b53b-e1d99855f0b2")
        jwtKeyObj.setX("AEGLQ3SbxrqrvlCpc4Qe9LpLmXx6bi-7VK2ZIWGIIjBQc8FpLjYW17CPtRcQ1DfHbfT-fuQfSXyzMKV9g9_oTTko")
        jwtKeyObj.setY("AHG604r7Tf8GLemeIvECI9df9VxP4OFkGAD99gcskRrmfuMikDgP10oCoqN43OPHYI-CLRjY71GLnL4eOFWb1PRP")
        jwtKeyObj.setAlg("ECDH-ES")
        jwtKeyObj.setExp("70000")
        jwtKeyObj.setUse("enc")
        return jwtKeyObj
    }
    """
    * def jwtKeyObj = jwtKeySetter()


  Scenario: Test Fileupload API Happy Path

    Given url URL
    Given headers headers.header_all_val
    And multipart file file = { read:'classpath:config/data/payloads/file_upload/VA_DL_Front.jpeg', filename: 'VA_DL_Front.jpeg' }
    When method post
    Then status 201
    And match response == {"fileId": "#notnull"}
    * print response

  Scenario: Test Fileupload API Happy Path with unencrypted image

    Given url URL
    Given headers headers.header_all_val
    And multipart file file = { read:'classpath:config/data/payloads/file_upload/VA_DL_Front.jpeg', filename: 'VA_DL_Front.jpeg' }
    When method post
    Then status 201
    And match response == {"fileId": "#notnull"}
    * print response

  Scenario: Test Fileupload API Happy Path with Encrypted image
    * def encryptedImage = cryptoUtil.encryptEcdh(jwtKeyObj, fileInBytes)
    Given url URL
    Given headers headers.header_all_val
    And multipart file file = {value: encryptedImage, filename: 'VA_DL_Front.jpeg' }
    When method post
    Then status 201
    And match response == {"fileId": "#notnull"}
    * print response

  Scenario: Test Fileupload API with multiple files

    Given url URL
    Given headers headers.header_all_val
    And multipart file file = { read:'classpath:config/data/payloads/file_upload/VA_DL_Front.jpeg', filename: 'VA_DL_Front.jpeg' }
    And multipart file file = { read:'classpath:config/data/payloads/file_upload/VA_DL_Front.jpeg', filename: 'VA_DL_Front.jpeg' }
    When method post
    Then status 201
    * print response
    And match response == {"fileId": "#notnull"}


  Scenario: Test Fileupload API with PUT

    Given url URL
    Given headers headers.header_all_val
    And multipart file file = { read:'classpath:config/data/payloads/file_upload/VA_DL_Front.jpeg', filename: 'VA_DL_Front.jpeg' }
    When method put
    Then status 405
    * print response
    And match response.errorDetails == [{"id":"200099","text":null,"developerText":"HTTP 405 Method Not Allowed"}]



  Scenario: Test Fileupload API with Empty file

    Given url URL
    Given headers headers.header_all_val
    Given request read('classpath:config/data/payloads/file_upload/zeroMB.jpeg')
    When method post
    Then status 400
    * print response.errorDetails
    And match response.errorDetails == [{"id":"200000","text":null,"developerText":"HTTP 400 Bad Request"}]


  Scenario: Test Fileupload API with invalid contentType

    Given url URL
    Given headers headers.header_wrong_contentType
    And multipart file file = { read:'classpath:config/data/payloads/file_upload/VA_DL_Front.jpeg', filename: 'VA_DL_Front.jpeg' }
    When method post
    Then status 415
    * print response.errorDetails
    And match response.errorDetails == [{"id":"200099","text":null,"developerText":"HTTP 415 Unsupported Media Type"}]


  Scenario: Test Fileupload API with invalid channelType

    Given url URL
    Given headers headers.header_wrong_ChannelType
    And multipart file file = { read:'classpath:config/data/payloads/file_upload/VA_DL_Front.jpeg', filename: 'VA_DL_Front.jpeg' }
    When method post
    Then status 400
    * print response.errorDetails
    And match response.errorDetails[0] == {"id":"200000","text":null,"developerText":"channel Type is not valid "}

  Scenario: Test Fileupload API with invalid customerIp

    Given url URL
    Given headers headers.header_wrong_customerIP
    And multipart file file = { read:'classpath:config/data/payloads/file_upload/VA_DL_Front.jpeg', filename: 'VA_DL_Front.jpeg' }
    When method post
    Then status 400
    * print response.errorDetails
    And match response.errorDetails[0] == {"id":"200000","text":null,"developerText":"Customer IP address is not valid"}


  Scenario: Test Fileupload API with empty customerIpAndChannelType

    Given url URL
    Given headers headers.header_empty_customerIPChannelType
    And multipart file file = { read:'classpath:config/data/payloads/file_upload/VA_DL_Front.jpeg', filename: 'VA_DL_Front.jpeg' }
    When method post
    Then status 201
    And match response == {"fileId": "#notnull"}
    * print response

  Scenario: Test Fileupload API with ccid is null

    Given url URL
    Given headers headers.header_no_ccid
    And multipart file file = { read:'classpath:config/data/payloads/file_upload/VA_DL_Front.jpeg', filename: 'VA_DL_Front.jpeg' }
    When method post
    Then status 400
    * print response
    And match response.errorDetails == [{"propertyPath":"uploadImage.arg0","id":"200000","text":null,"developerText":"CCID must not be null"}]}

  # file upload api has not been set up to work in the local environment. Unsure of how to configure.
  @envnot=local
  Scenario: Test Fileupload API with virus scan failed

    Given url URL
    Given headers headers.header_all_val
    And multipart file file = { read:'classpath:config/data/payloads/file_upload/Virus.jpeg', filename: 'Virus.jpeg' }
    When method post
    Then status 400
    * print response.errorDetails
    And match response.errorDetails == [{"id":"200000","text":null,"developerText":"Document failed at virus scan service"}]



  Scenario: Test Fileupload API with file size more than 10MB

    Given url URL
    Given headers headers.header_all_val
    And multipart file file = { read:'classpath:config/data/payloads/file_upload/11MB.jpeg', filename: '11MB.jpeg' }
    When method post
    Then status 400
    * print response.errorDetails
    And match response.errorDetails == [{"id":"200000","text":null,"developerText":"document size is greater than 10MB"}]


  Scenario: Test Fileupload API with productId is null

    Given url URL
    Given headers headers.header_no_productId
    And multipart file file = { read:'classpath:config/data/payloads/file_upload/VA_DL_Front.jpeg', filename: 'VA_DL_Front.jpeg' }
    When method post
    Then status 201
    And match response == {"fileId": "#notnull"}
    * print response


  Scenario: Test Fileupload API with document is empty should throw virus-scan error

    Given url URL
    Given headers headers.header_no_productId
    And multipart file file = { read:'classpath:config/data/payloads/file_upload/empty.jpeg', filename: 'empty.jpeg' }
    When method post
    Then status 500
    * print response
    And match response.errorDetails == [{"id":"200099","text":null,"developerText":"Exception while scanning files for virus"}]


  Scenario: Test Fileupload API with invalid productId should throws encryption error

    Given url URL
    Given headers headers.header_wrong_productId
    And multipart file file = { read:'classpath:config/data/payloads/file_upload/VA_DL_Front.jpeg', filename: 'VA_DL_Front.jpeg' }
    When method post
    Then status 400
    * print response
    And match response.developerText == "Response from KRP API was empty. ProductId may be invalid or KRP API unavailable."
	