Feature: Generic test for Masterbuilder functionality. Test missing/invalid headers and request data types.

    Background:
#	    * configure headers = req_headers
	    * def payloads = read('classpath:config/data/payloads/mb_process_payload.yml')
	    * def responses = read('classpath:config/data/responses/mb_process_response.yml')
	    * configure charset = null
	    * configure ssl = enableSSL
	    * def decoder = read('classpath:features/utilities/decodeWorkflow.js') 
		* def validateResponse = read('classpath:features/utilities/one_step.feature')
    	* def customHeadersReq = read('classpath:features/utilities/custom_headers.feature')
		* def noWfResponse = read('classpath:features/utilities/one_step.feature')
    
    Scenario: Missing values in the headers
    	* def headerList = read('classpath:config/data/payloads/headers.yml')
    	* json noAPIKey = headerList.masterbuilder_header_NoAPIKey
    	* json noClientCorrelationId = headerList.header_client_corr_ID
    	* json noCustomerIp = headerList.masterbuilder_header_client_IP
    	* json noChannelType = headerList.header_channel_type
    	* json noContentType = headerList.header_no_contentType
    	
#     * call customHeadersReq { headers: '#(noAPIKey)', payload: '#(payloads.mb_valid_CCPA_req)', response: '#(responses.mb_missing_APIKey_res)', httpStatus: 403 }
#	    * call customHeadersReq { headers: '#(noClientCorrelationId)', payload: '#(payloads.mb_valid_CCPA_req)', response: '#(responses.mb_missing_correlationId_res)', httpStatus: 400 }
#	    * call customHeadersReq { headers: '#(noCustomerIp)', payload: '#(payloads.mb_valid_CCPA_req)', response: '#(responses.mb_missing_customerIp_res)', httpStatus: 400 }
#	    * call customHeadersReq { headers: '#(noChannelType)', payload: '#(payloads.mb_valid_CCPA_req)', response: '#(responses.mb_missing_channelType_res)', httpStatus: 400 }
#	    * call customHeadersReq { headers: '#(noContentType)', payload: '', response: '#(responses.mb_missing_contentType_res)', httpStatus: 415 }

	Scenario: The requested policy does not exist
		* def URL = URL + '/fake_policy/1.0'
		* call noWfResponse { payload: '#(payloads.nonexistent_policy_req)', response: '#(responses.nonexistent_policy_res)', httpStatus: 404 }

	Scenario: Invalid values in the Process Initiator fields
        * configure headers = req_headers
#        * call validateResponse { payload: '#(payloads.mb_invalid_clientId_req)', response: '#(responses.mb_invalid_process_initiator_res)', httpStatus: 400 }
#        * call validateResponse { payload: '#(payloads.mb_invalid_processName_req)', response: '#(responses.mb_invalid_process_initiator_res)', httpStatus: 400 }
#        * call validateResponse { payload: '#(payloads.mb_invalid_version_req)', response: '#(responses.mb_invalid_process_initiator_res)', httpStatus: 400 }

    Scenario: Missing values in the Process Initiator fields
        * configure headers = req_headers
 #       * call validateResponse { payload: '#(payloads.mb_missing_clientId_req)', response: '#(responses.mb_invalid_process_initiator_res)', httpStatus: 400 }
 #       * call validateResponse { payload: '#(payloads.mb_missing_processName_req)', response: '#(responses.mb_invalid_process_initiator_res)', httpStatus: 400 }
 #       * call validateResponse { payload: '#(payloads.mb_missing_version_req)', response: '#(responses.mb_invalid_process_initiator_res)', httpStatus: 400 }

    Scenario: Invalid / Missing values for Process Digest
       * configure headers = req_headers
  #      * call validateResponse { payload: '#(payloads.mb_expired_pd_req)', response: '#(responses.mb_expired_pd_res)', httpStatus: 400 }
   #     * call validateResponse { payload: '#(payloads.mb_missing_pd_req)', response: '#(responses.mb_missing_pd_res)', httpStatus: 400 }