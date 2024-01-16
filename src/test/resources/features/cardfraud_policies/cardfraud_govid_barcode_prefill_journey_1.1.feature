@cardfraud_govid_barcode_prefil_journey_1.1_tag
Feature: Cardfraud GovidbarcodePrefil API integration tests

 ########################### defining requests and responses
  Background:
    * configure headers = req_headers
    * def payloads = read('classpath:config/data/payloads/barcode_prefill/barcode_prefill_1.1_payload.yml')
    * def responses = read('classpath:config/data/responses/barcode_prefill/barcode_prefill_1.1_response.yml')
    * def decoder = read('classpath:features/utilities/decodeWorkflow.js')
    * def wfResponse = read('classpath:features/utilities/response_step.feature')
    * def noWfResponse = read('classpath:features/utilities/one_step.feature')
    * configure charset = null
    * configure ssl = enableSSL
    * def URL = URL + '?policyName=barcode_prefill&policyVersion=1.1'

    ###################### Positive Scenario #########################

  @cardfraud_govid_barcode_prefil_journey_1.1_tag1
  Scenario: Validating Success scenario for GovidBarcodePrefil Journey Policy with mandatory fields
    * call wfResponse { payload: '#(payloads.govid_barcode_prefil_journey_required_fields_req)', response: '#(responses.govid_barcode_prefill_journey_response)', httpStatus: 200 }

    ###################### Error Scenarios #########################

  @cardfraud_govid_barcode_prefil_journey_1.1_tag2
  Scenario: Validating Unhappy path for GovIdBarcodePrefil Policy with missing  barcode mandatory fields
    * call noWfResponse { payload: '#(payloads.govid_barcode_prefil_journey_missing_barcode_req)', response: '#(responses.govid_barcode_prefill_journey_missing_barcode_resp)', httpStatus: 200 }

  @cardfraud_govid_barcode_prefil_journey_1.1_tag3
  Scenario: Validating Unhappy path for GovIdBarcodePrefil Policy with missing  location mandatory field
    * call noWfResponse { payload: '#(payloads.govid_barcode_prefil_journey_missing_barcodedeviceId_req)', response: '#(responses.govid_barcode_prefill_journey_missing_barcodedeviceId_resp)', httpStatus: 200 }

  @cardfraud_govid_barcode_prefil_journey_1.1_tag4
  Scenario: Validating Unhappy path for GovIdBarcodePrefil Policy with missing all mandatory fields
    * call noWfResponse { payload: '#(payloads.govid_barcode_prefil_journey_missing_allFields_req)', response: '#(responses.govid_barcode_prefill_journey_missing_allfields_resp)', httpStatus: 200 }


  @cardfraud_govid_barcode_prefil_journey_1.1_tag6
  Scenario: Validating Unhappy path for GovIdBarcodePrefil Policy with invalid businessUnit
    * call noWfResponse { payload: '#(payloads.govid_barcode_prefil_journey_invalid_businessunit_req)', response: '#(responses.govid_barcode_prefil_journey_invalid_businessuni_resp)', httpStatus: 200 }

  @cardfraud_govid_barcode_prefil_journey_1.1_tag7
  Scenario: Validating Unhappy path for GovIdBarcodePrefil Policy with invalid location
    * call noWfResponse { payload: '#(payloads.govid_barcode_prefil_journey_invalid_location_req)', response: '#(responses.govid_barcode_prefil_journey_invalid_location_resp)', httpStatus: 200 }

  @cardfraud_govid_barcode_prefil_journey_1.1_tag8
  Scenario: Validating Unhappy path for GovIdBarcodePrefil Policy with invalid barcode
    * call noWfResponse { payload: '#(payloads.govid_barcode_prefil_journey_invalidBarCode_req)', response: '#(responses.govid_barcode_prefil_journey_invalid_barcode_resp)', httpStatus: 200 }

#   @cardfraud_govid_barcode_prefil_journey_1.1_tag9
#   Scenario: Validating Unhappy path for GovIdBarcodePrefil Policy with empty barcode
#     * call noWfResponse { payload: '#(payloads.govid_barcode_prefil_journey_emptyBarCode_req)', response: '#(responses.govid_barcode_prefil_journey_emptyBarCode_resp)', httpStatus: 200 }


  @cardfraud_govid_barcode_prefil_journey_1.1_tag11
  Scenario: Validating Unhappy path for GovIdBarcodePrefil Policy with empty BusinessUnit and Location
    * call noWfResponse { payload: '#(payloads.govid_barcode_prefil_journey_emptyBusinessUnitLocation_req)', response: '#(responses.govid_barcode_prefil_journey_emptyBusinessUnitLocation_resp)', httpStatus: 200 }

  @cardfraud_govid_barcode_prefil_journey_1.1_tag12
  Scenario: Validating Unhappy path for GovIdBarcodePrefil Policy with empty model
    * call noWfResponse { payload: '#(payloads.govid_barcode_prefil_journey_emptyModel_req)', response: '#(responses.govid_barcode_prefil_journey_emptyModel_resp)', httpStatus: 200 }