package com.capitalone.identity.identitybuilder.verification;

import com.capitalone.identity.identitybuilder.policycore.camel.ListStrategy;
import com.capitalone.identity.identitybuilder.policycore.decisionengine.DecisionEngineResult;
import com.capitalone.utils.CamelSpringBootContextAwareTest;
import com.capitalone.utils.TestUtils;
import com.google.common.base.Charsets;
import com.google.common.io.Resources;
import org.apache.camel.*;
import org.apache.camel.component.mock.InterceptSendToMockEndpointStrategy;
import org.apache.camel.component.mock.MockEndpoint;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.test.annotation.DirtiesContext;

import java.io.IOException;
import java.util.*;

@CamelSpringBootContextAwareTest(contextConfigClasses = AccountLookupV13Test.ContextConfig.class,
        excludeFromComponentScan = @ComponentScan.Filter(type = FilterType.ASPECTJ,
                pattern = "com.capitalone.identity.identitybuilder.verification.*"))
@DirtiesContext(classMode = DirtiesContext.ClassMode.AFTER_EACH_TEST_METHOD)
public class AccountLookupV13Test implements PolicyTestSupportExchange {

    @Autowired
    private CamelContext camelContext;


    @Autowired @Qualifier("policyTemplate")
    protected ProducerTemplate policyTemplate;

    @Autowired @Qualifier("schemaTemplate")
    protected ProducerTemplate schemaTemplate;

    @Override
    public CamelContext camelContext() {
        return this.camelContext;
    }

    @Configuration
    public static class ContextConfig {

      @Bean
      CamelContext createCamelContext() {
        final CamelContext camelContext = CamelContextTestUtil.createDefaultCamelContext();
        CamelContextTestUtil.loadProcessXml("account_lookup_1.3.xml", camelContext);
        camelContext.getPropertiesComponent().setInitialProperties(setTestProperties());
        camelContext.getRegistry().bind("listStrategy", new ListStrategy());
        final String ignoredEndpointsPattern = "domain:/verification/barcode_retrieve/1.1|" +
            "direct:DmnRulesComponent_DmnGovIdBarcode|" +
            "direct:DmnRulesComponent_AccountLookup|" +
            "domain:/verification/matching/1.2|" +
            "direct:DmnRulesComponent_MatchingStatusCheck";
        camelContext.adapt(ExtendedCamelContext.class)
            .registerEndpointCallback(new InterceptSendToMockEndpointStrategy(ignoredEndpointsPattern, true));
        return camelContext;
      }

      @Bean (name = "policyTemplate")
      ProducerTemplate createPolicyProducerTemplate(final CamelContext camelContext) {
        final ProducerTemplate producerTemplate = camelContext.createProducerTemplate();
        producerTemplate.setDefaultEndpointUri("policy:account_lookup_1.3");
        return producerTemplate;
      }

      @Bean (name = "schemaTemplate")
      ProducerTemplate createSchemaProducerTemplate(final CamelContext camelContext) {
        final ProducerTemplate producerTemplate = camelContext.createProducerTemplate();
        producerTemplate.setDefaultEndpointUri("direct:account_lookup_1.3-schema");
        return producerTemplate;
      }

      private Properties setTestProperties() {
            Properties props = new Properties();
            props.put("schema.brandCodes", "\"BASSPRO\", \"BERGDORFGOODMANPLCC\",\"CABELAS\", \"GMBP\", \"GMEF\", \"GMSB\", \"IBTCR\", \"IBTPA\", \"IBTRA\", \"JOURNEY\", \"MENARDSPLCC\", \"NEIMANMARCUSPLCC\",\"PLATINUM\", \"PLATINUM_PREFERRED\", \"PLAYSTATION\", \"QUICKSILVER\", \"QUICKSILVERONE\", \"SAKSCB\", \"SAKSOFFFIFTHPLCC\", \"SAKSPLCC\", \"SAKSPLCCDA\", \"SAVOR\",\"SAVORONE\",\"SECUREDCARD\", \"SONY\", \"SPARK750ESB\", \"SPARKCASH\", \"SPARKCASHRM\", \"SPARKCASHSELECT\", \"SPARKCASHTS\",\"SPARKCLASSIC\", \"SPARKMILES\", \"SPARKMILESSELECT\", \"SPARKPRO\", \"UPCR\", \"UPPA\", \"UPRA\",\"VENTURE\",\"VENTUREONE\",\"WALMARTCB\", \"WALMARTPLCCDA\", \"WALMARTPLUS\", \"KEYREWARDSWSICB\", \"KEYREWARDSWSIPLCC\", \"POTTERYBARNCB\",\"POTTERYBARNPLCC\", \"WESTELMCB\", \"WESTELMPLCC\", \"WILLIAMSSONOMACB\", \"WILLIAMSSONOMAPLCC\", \"SPORTSMANS\"");
            props.put("schema.originators", "\"APPLYANDBUY\", \"ASSOCIATE\", \"INLANEBYOD\", \"INLANESCO\", \"KIOSK\",\"OUTOFLANEBYOD\", \"PHONE\", \"POS\", \"TABLET\", \"TEXTTOAPPLY\", \"UNS\", \"WEB\", \"RECOURSE\",\"POSTBOOK\", \"REALTIME\",\"PREAPPROVALAPPLYANDBUY\", \"PREAPPROVALUNS\", \"PREAPPROVALASSOCIATE\",\"PREAPPROVALINLANESCO\", \"PREAPPROVALOUTOFLANEBYOD\", \"PREAPPROVALPOS\", \"PREAPPROVALAFF\"");
            return props;
        }
    }

    private Exchange exchange;

    // Testing data ----------------------------------------------------------------------------------------------------

    // Information passed into the Account Lookup policy
    private static final String post_barcode = "barcodeValue";
    private static final String post_businessUnit = "businessUnitValue";
    private static final String post_model = "modelValue";
    private static final String post_configId = "configIdValue";
    private static final String post_copyText = "copyTextValue";
    private static final String post_deviceId = "deviceIdValue";
    private static final String post_location = "locationValue";
    private static final String post_customerReferenceIdA = "customerReferenceIdValueA";
    private static final String post_customerReferenceIdB = "customerReferenceIdValueB";
    private static final ArrayList<String> post_customerReferenceId = new ArrayList<>(Arrays.asList(post_customerReferenceIdA));
    private static final ArrayList<String> post_customerReferenceIds = new ArrayList<>(Arrays.asList(post_customerReferenceIdA, post_customerReferenceIdB));

    // Information returned from domain:/verification/barcode_retrieve/1.1

    private static final String barcodeRetrieve_countryCode = "countryCodeValue";
    private static final String barcodeRetrieve_referenceId = "referenceIdValue";
    private static final String barcodeRetrieve_issueStateCode = "issueStateCodeValue";
    private static final String barcodeRetrieve_documentStatus = "documentStatusValue";
    private static final String barcodeRetrieve_expirationDate = "2050-10-16";
    private static final String barcodeRetrieve_badDate = "InvalidDate";

    // Information returned from account_lookup_1.3_GovIdBarcode.dmn
    private static final String govidBarcode_routeMN = "MN";
    private static final String govidBarcode_routeGA = "NotCompleteOrMN";
    private static final String govidBarcode_routeComplete = "complete";
    private static final String govidBarcode_documentValidityStatus = "documentValidityStatusValue_govidBarcode";
    private static final String govidBarcode_documentFailureReason = "documentFailureReasonValue_govidBarcode";

    // Information returned from account_lookup_1.3_AccountLookup--.dmn
    private static final String accountLookup_documentValidityStatus = "documentValidityStatusValue_accountLookup";
    private static final String accountLookup_documentFailureReason = "documentFailureReasonValue_accountLookup";

    // Information returned from domain:/verification/matching/1.2
    private static final String matching_errorInfo = "{id=202020, text=Downstream API error, developerText=Downstream API";
    private static final String matching_customerReferenceId = "matching_customerReferenceIdValue";
    private static final String matching_firstNameScore = "999";
    private static final String matching_lastNameScore = "888";
    private static final String matching_dateOfBirthScore = "777";

    // Information returned from account_lookup_1.3_MatchingStatusCheck.dmn
    private static final String matchingStatusCheck_customerMatchStatus = "customerMatchStatusValue";
    private static final String matchingStatusCheck_matchFailureReason = "matchFailureReasonValue";
    private static final String matchingStatusCheck_customerMatchStatusB = "customerMatchStatusValueB";
    private static final String matchingStatusCheck_matchFailureReasonB = "matchFailureReasonValueB";

    // Possible Date check results
    private static final String dateINVALID = "INVALID";
    private static final String dateValid = "VALID";
    private static final String dateNULL = "NULL";

    enum barcodeRetrieveResponses {
        FOUND_ID, NULL_DATES, INVALID_BARCODE, ERROR_RESPONSE
    }

    enum barcodeRetrievePropertiesToggle {
        GOOD_DATES, NULL_DATES, NULL_FIELDS, BAD_DATES
    }

    enum matchingResponse {
        GOOD_MATCH, ERROR_RESPONSE, ERROR_MESSAGE
    }

    // Data files
    private static final String SCHEMA = "data/account_lookup/account_lookup_1.3_schema.json";
    private static final String BARCODERETRIEVE = "data/account_lookup/account_lookup_1.3_barcodeRetrieveResponse.json";
    private static final String BARCODERETRIEVE_INVALID = "data/account_lookup/account_lookup_1.3_barcodeRetrieveResponse_Invalid.json";
    private static final String BARCODERETRIEVE_ERROR = "data/account_lookup/account_lookup_1.3_barcodeRetrieveResponse_Error.json";
    private static final String MATCHING = "data/account_lookup/account_lookup_1.3_matchingResponse.json";
    private static final String MATCHING_ERROR = "data/account_lookup/account_lookup_1.3_matchingResponse_Error.json";

    // Endpoint Responses ----------------------------------------------------------------------------------------------

    private Map<String, Object> barcodeRetrieveResponse(barcodeRetrieveResponses responseToggle, String expirationDate) throws IOException {

        // Handle setup of non-standard responses
        switch (responseToggle) {
            case INVALID_BARCODE:
                String jsonInvalid = Resources.toString(Resources.getResource(BARCODERETRIEVE_INVALID), Charsets.UTF_8);
                Map<String, Object> jsonInvalidMap = jsonToMap(jsonInvalid);
                jsonInvalidMap.put("referenceId", barcodeRetrieve_referenceId);
                jsonInvalidMap.put("documentStatus", barcodeRetrieve_documentStatus);
                return jsonInvalidMap;
            case ERROR_RESPONSE:
                String jsonError = Resources.toString(Resources.getResource(BARCODERETRIEVE_ERROR), Charsets.UTF_8);
                return jsonToMap(jsonError);
        }

        // Handle setup of standard responses
        String jsonGood = Resources.toString(Resources.getResource(BARCODERETRIEVE), Charsets.UTF_8);
        Map<String, Object> jsonGoodMap = jsonToMap(jsonGood);
        jsonGoodMap.put("documentStatus", barcodeRetrieve_documentStatus);
        jsonGoodMap.put("referenceId", barcodeRetrieve_referenceId);

        Map<String, Object> documentData = (Map<String, Object>) jsonGoodMap.get("documentData");
        documentData.put("countryCode", barcodeRetrieve_countryCode);

        Map<String, Object> biographic = (Map<String, Object>) documentData.get("biographic");
        biographic.put("issueStateCode",barcodeRetrieve_issueStateCode);

        switch (responseToggle) {
            case FOUND_ID:
                biographic.put("expirationDate",expirationDate);
                break;
            case NULL_DATES:
                biographic.put("expirationDate",null);
                break;
        }

        documentData.put("biographic", biographic);
        jsonGoodMap.put("documentData", documentData);

        return jsonGoodMap;
    }

    private DecisionEngineResult dmnGovIdBarcodeResponse(String route) throws IOException {
        String dmnResult = "{" +
                "\"results\": {" +
                "\"route\": \"" + route + "\"," +
                "\"documentValidityStatus\": \""+ govidBarcode_documentValidityStatus +"\"," +
                "\"documentFailureReason\": \""+ govidBarcode_documentFailureReason + "\"" +
                "}" +
                "}";

        return new DecisionEngineResult("results", jsonToMap(dmnResult));
    }

    private DecisionEngineResult dmnAccountLookupResponse() throws IOException {
        String dmnResult = "{" +
                "\"results\": {" +
                "\"documentValidityStatus\": \""+ accountLookup_documentValidityStatus +"\"," +
                "\"documentFailureReason\": \""+ accountLookup_documentFailureReason + "\"" +
                "}" +
                "}";

        return new DecisionEngineResult("results", jsonToMap(dmnResult));
    }

    private Map<String, Object> matchingResponse(matchingResponse responseToggle, String customerReferenceId) throws IOException {
        switch (responseToggle) {
            case GOOD_MATCH:
                String json = Resources.toString(Resources.getResource(MATCHING), Charsets.UTF_8);
                Map<String, Object> jsonMap = jsonToMap(json);
                jsonMap.put("customerReferenceId", customerReferenceId);
                jsonMap.put("lastNameScore", matching_lastNameScore);
                jsonMap.put("dateOfBirthScore", matching_dateOfBirthScore);
                jsonMap.put("firstNameScore", matching_firstNameScore);
                return jsonMap;
            case ERROR_RESPONSE:
                String jsonError = Resources.toString(Resources.getResource(MATCHING_ERROR), Charsets.UTF_8);
                return jsonToMap(jsonError);
        }
        return null;
    }

    private DecisionEngineResult dmnMatchingStatusCheckResponse(String customerMatchStatus, String matchFailureReason) throws IOException {
        String dmnResult = "{" +
                "\"results\": {" +
                "\"customerMatchStatus\": \"" + customerMatchStatus + "\"," +
                "\"matchFailureReason\": \"" + matchFailureReason + "\"" +
                "}" +
                "}";

        return new DecisionEngineResult("results", jsonToMap(dmnResult));
    }

    // Mocks -----------------------------------------------------------------------------------------------------------

    private void createBarcodeRetrieveMock(Map<String, Object> barcodeRetrieveResponse) {
        MockEndpoint mockBarcodeRetrieveEndpoint = TestUtils.mockEndpoint(camelContext, "mock:domain:/verification/barcode_retrieve/1.1");
        mockBarcodeRetrieveEndpoint.whenAnyExchangeReceived(exchange -> {
            exchange.getIn().setHeader("unitTestBodyBarcodeRetrieve", exchange.getIn().getBody().toString());
            exchange.getIn().setBody(barcodeRetrieveResponse);
        });
    }

    private void createBarcodeRetrieveErrorMock(Map<String, Object> barcodeRetrieveResponse) {
        MockEndpoint mockBarcodeRetrieveEndpoint = TestUtils.mockEndpoint(camelContext, "mock:domain:/verification/barcode_retrieve/1.1");
        mockBarcodeRetrieveEndpoint.whenAnyExchangeReceived(exchange -> {
            exchange.getIn().setHeader("unitTestBodyBarcodeRetrieve", exchange.getIn().getBody().toString());
            exchange.getIn().setBody(barcodeRetrieveResponse);
            throw new Exception();
        });
    }

    private void createDmnGovIdBarcodeMock(DecisionEngineResult dmnGovIdBarcodeResponse) {
        MockEndpoint mockGovIdBarcodeEndpoint = TestUtils.mockEndpoint(camelContext, "mock:direct:DmnRulesComponent_DmnGovIdBarcode");
        mockGovIdBarcodeEndpoint.whenAnyExchangeReceived(exchange -> {
            exchange.getIn().setHeader("unitTestBodyDmnGovIdBarcode", exchange.getIn().getBody().toString());
            exchange.getIn().setHeader("policyRuleResult", dmnGovIdBarcodeResponse);
        });
    }

    private void createDmnAccountLookupMock(DecisionEngineResult dmnAccountLookupResponse) {
        MockEndpoint mockAccountLookupEndpoint = TestUtils.mockEndpoint(camelContext, "mock:direct:DmnRulesComponent_AccountLookup");
        mockAccountLookupEndpoint.whenAnyExchangeReceived(exchange -> {
            exchange.getIn().setHeader("unitTestBodyDmnAccountLookup", exchange.getIn().getBody().toString());
            exchange.getIn().setHeader("policyRuleResult", dmnAccountLookupResponse);
        });
    }

    private void createMatchingMock(Map<String, Object> matchingResponse) {
        MockEndpoint mockCustomerInformationEndpoint = TestUtils.mockEndpoint(camelContext, "mock:domain:/verification/matching/1.2");
        mockCustomerInformationEndpoint.whenAnyExchangeReceived(exchange -> {
            exchange.getIn().setHeader("unitTestBodyMatching", exchange.getIn().getBody().toString());
            exchange.getIn().setBody(matchingResponse);
        });
    }

    private void createMatchingErrorMock(Map<String, Object> matchingResponse) {
        MockEndpoint mockMatchingErrorEndpoint = TestUtils.mockEndpoint(camelContext, "mock:domain:/verification/matching/1.2");
        mockMatchingErrorEndpoint.whenAnyExchangeReceived(exchange -> {
            exchange.getIn().setHeader("unitTestBodyMatching", exchange.getIn().getBody().toString());
            exchange.getIn().setBody(matchingResponse);
            exchange.getIn().setHeader("httpStatus", 200);
            throw new Exception();
        });
    }

    private void createDmnMatchingStatusCheckMock(DecisionEngineResult dmnMatchingStatusCheckResponse) {
        MockEndpoint mockMatchingStatusCheckEndpoint = TestUtils.mockEndpoint(camelContext, "mock:direct:DmnRulesComponent_MatchingStatusCheck");
        mockMatchingStatusCheckEndpoint.whenAnyExchangeReceived(exchange -> {
            exchange.getIn().setHeader("unitTestBodyDmnMatchingStatusCheck", exchange.getIn().getBody().toString());
            exchange.getIn().setHeader("policyRuleResult", dmnMatchingStatusCheckResponse);
        });
    }

    // Tests -----------------------------------------------------------------------------------------------------------

    @BeforeEach
    public void setup() {
        ArrayList<String> customerReferenceIds = new ArrayList<>();
        customerReferenceIds.add(post_customerReferenceIdA);

        Map<String, Object> params = new HashMap<>();
        params.put("customerReferenceIds", customerReferenceIds);

        params.put("govtIdRequest", createGovtIdRequest());

        exchange = policyExchange(params, null);

        camelContext.start();
    }

    /**
     * Validate that the schema is available and unchanged.
     */
    @Test
    public void testSchema_MatchesExpected() throws IOException {
        exchange = policyExchange(null, null);
        schemaTemplate.send(exchange);
        Assertions.assertNull(exchange.getException());
        String json = Resources.toString(Resources.getResource(SCHEMA), Charsets.UTF_8);
        Assertions.assertEquals(jsonToMap(json), jsonToMap(exchange.getIn().getBody(String.class)));
    }

    @Test
    public void testOneCustomer_FullRun_Default_GoodDates() throws IOException {
        testOneCustomer_FullRun(govidBarcode_routeGA, "Default", barcodeRetrievePropertiesToggle.GOOD_DATES);
    }

    @Test
    public void testOneCustomer_FullRun_MN_GoodDates() throws IOException {
        testOneCustomer_FullRun(govidBarcode_routeMN, govidBarcode_routeMN, barcodeRetrievePropertiesToggle.GOOD_DATES);
    }

    @Test
    public void testOneCustomer_FullRun_MN_BadDates() throws IOException {
        testOneCustomer_FullRun(govidBarcode_routeMN, govidBarcode_routeMN, barcodeRetrievePropertiesToggle.BAD_DATES);
    }

    @Test
    public void testOneCustomer_FullRun_MN_NullDates() throws IOException {
        testOneCustomer_FullRun(govidBarcode_routeMN, govidBarcode_routeMN, barcodeRetrievePropertiesToggle.NULL_DATES);
    }

    @Test
    public void testOneCustomer_InvalidBarcode_ExitsAt_RouteComplete() throws IOException {
        createBarcodeRetrieveMock(barcodeRetrieveResponse(barcodeRetrieveResponses.INVALID_BARCODE, barcodeRetrieve_expirationDate));
        createDmnGovIdBarcodeMock(dmnGovIdBarcodeResponse(govidBarcode_routeComplete));
        createDmnAccountLookupMock(null);
        createMatchingMock(null);
        createDmnMatchingStatusCheckMock(null);

        runAndVerify_StopAfterDMNGovIDBarcode();

        checkInitialSetup(post_customerReferenceIdA);
        checkValuesPassedTo_BarcodeRetrieve();
        checkProperties_AfterBarcodeRetrieve(barcodeRetrievePropertiesToggle.NULL_FIELDS);
        checkValuesPassedTo_DMNGovIdBarcode(barcodeRetrieve_documentStatus, "null");

        // The policy will bail out when it hits the check for ['route'] == "complete"
        // Make sure it has the expected values in the final body
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("documentValidityStatus=" + govidBarcode_documentValidityStatus));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("documentFailureReason=" + govidBarcode_documentFailureReason));
    }

    @Test
    public void testOneCustomer_ExitsAt_BarcodeRetrieve_Exception() throws IOException {
        createBarcodeRetrieveErrorMock(barcodeRetrieveResponse(barcodeRetrieveResponses.ERROR_RESPONSE, barcodeRetrieve_expirationDate));
        createDmnGovIdBarcodeMock(null);
        createDmnAccountLookupMock(null);
        createMatchingMock(null);
        createDmnMatchingStatusCheckMock(null);

        runAndVerify_BarcodeRetrieveException();

        checkInitialSetup(post_customerReferenceIdA);
        checkValuesPassedTo_BarcodeRetrieve();

        // The exception from Barcode Retrieve will cause the policy to stop when it's returned
        // Make sure it has the expected values in the final body
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("id=20202"));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("text=Downstream API error"));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("developerText=The verification domain policy"));
    }

    @Test
    public void testOneCustomer_ExitsAt_Matching_Exception() throws IOException {
        createBarcodeRetrieveMock(barcodeRetrieveResponse(barcodeRetrieveResponses.FOUND_ID, barcodeRetrieve_expirationDate));
        createDmnGovIdBarcodeMock(dmnGovIdBarcodeResponse(govidBarcode_routeGA));
        createDmnAccountLookupMock(dmnAccountLookupResponse());
        createMatchingErrorMock(matchingResponse(matchingResponse.ERROR_RESPONSE, matching_customerReferenceId));
        createDmnMatchingStatusCheckMock(null);

        runAndVerify_MatchingException();

        checkInitialSetup(post_customerReferenceIdA);
        checkValuesPassedTo_BarcodeRetrieve();
        checkProperties_AfterBarcodeRetrieve(barcodeRetrievePropertiesToggle.GOOD_DATES);
        checkValuesPassedTo_DMNGovIdBarcode(barcodeRetrieve_documentStatus, barcodeRetrieve_issueStateCode);
        Assertions.assertTrue(exchange.getProperty("dmn").toString().contains("Default"));
        checkDates(dateValid);
        checkValuesPassedTo_DMNAccountLookup("Default", barcodeRetrieve_expirationDate);
        checkValuesPassedTo_Matching(barcodeRetrieve_referenceId, post_customerReferenceIdA);

        // Make sure it has the expected values in the final body
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("customerReferenceId=" + post_customerReferenceIdA));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("customerMatchStatus=NonDefinitive"));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("matchFailureReason=" + matching_errorInfo));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("documentValidityStatus=" + accountLookup_documentValidityStatus));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("documentFailureReason=" + accountLookup_documentFailureReason));
    }

    @Test
    public void testTwoCustomers_FullRun_DefaultDMN_GoodDates() throws IOException, InterruptedException {
        Map<String, Object> params = new HashMap<>();

        ArrayList<String> customerReferenceIds = new ArrayList<>();
        customerReferenceIds.add(post_customerReferenceIdA);
        customerReferenceIds.add(post_customerReferenceIdB);
        params.put("customerReferenceIds", customerReferenceIds);

        params.put("govtIdRequest", createGovtIdRequest());

        exchange = policyExchange(params, null);

        createBarcodeRetrieveMock(barcodeRetrieveResponse(barcodeRetrieveResponses.FOUND_ID, barcodeRetrieve_expirationDate));
        createDmnGovIdBarcodeMock(dmnGovIdBarcodeResponse(govidBarcode_routeGA));
        createDmnAccountLookupMock(dmnAccountLookupResponse());

        MockEndpoint mockMatchingEndpoint = TestUtils.mockEndpoint(camelContext, "mock:domain:/verification/matching/1.2");
        mockMatchingEndpoint.setExpectedCount(2);
        mockMatchingEndpoint.whenExchangeReceived(1, exchange -> {
            exchange.getIn().setHeader("unitTestBodyMatching", exchange.getIn().getBody().toString());
            exchange.getIn().setBody(matchingResponse(matchingResponse.GOOD_MATCH, post_customerReferenceIdA));
        });
        mockMatchingEndpoint.whenExchangeReceived(2, exchange -> {
            exchange.getIn().setHeader("unitTestBodyMatching", exchange.getIn().getBody().toString());
            exchange.getIn().setBody(matchingResponse(matchingResponse.GOOD_MATCH, post_customerReferenceIdB));
        });

        MockEndpoint mockMatchingStatusCheckEndpoint = TestUtils.mockEndpoint(camelContext, "mock:direct:DmnRulesComponent_MatchingStatusCheck");
        mockMatchingStatusCheckEndpoint.setExpectedCount(2);
        mockMatchingStatusCheckEndpoint.whenExchangeReceived(1, exchange -> {
            exchange.getIn().setHeader("unitTestBodyDmnMatchingStatusCheck", exchange.getIn().getBody().toString());
            exchange.getIn().setHeader("policyRuleResult", dmnMatchingStatusCheckResponse(matchingStatusCheck_customerMatchStatus, matchingStatusCheck_matchFailureReason));
        });
        mockMatchingStatusCheckEndpoint.whenExchangeReceived(2, exchange -> {
            exchange.getIn().setHeader("unitTestBodyDmnMatchingStatusCheck", exchange.getIn().getBody().toString());
            exchange.getIn().setHeader("policyRuleResult", dmnMatchingStatusCheckResponse(matchingStatusCheck_customerMatchStatusB, matchingStatusCheck_matchFailureReasonB));
        });

        runAndVerify_FullRun();

        mockMatchingEndpoint.assertIsSatisfied();
        mockMatchingStatusCheckEndpoint.assertIsSatisfied();

        checkInitialSetup(post_customerReferenceIdA);
        checkValuesPassedTo_BarcodeRetrieve();
        checkProperties_AfterBarcodeRetrieve(barcodeRetrievePropertiesToggle.GOOD_DATES);
        checkValuesPassedTo_DMNGovIdBarcode(barcodeRetrieve_documentStatus, barcodeRetrieve_issueStateCode);
        Assertions.assertTrue(exchange.getProperty("dmn").toString().contains("Default"));
        checkDates(dateValid);
        checkValuesPassedTo_DMNAccountLookup("Default", barcodeRetrieve_expirationDate);

        // Make sure it has the expected values in the final body
        checkFinalValues_FullRun_TwoCustomers();
    }

    // Test methods ----------------------------------------------------------------------------------------------------

    private Map<String, Object> createGovtIdRequest() {
        Map<String, Object> govtIdRequest = new HashMap<>();
        govtIdRequest.put("barcode", post_barcode);
        govtIdRequest.put("deviceId", post_deviceId);
        govtIdRequest.put("location", post_location);
        govtIdRequest.put("businessUnit", post_businessUnit);
        govtIdRequest.put("model", post_model);
        govtIdRequest.put("copyText", post_copyText);
        govtIdRequest.put("configId", post_configId);
        return govtIdRequest;
    }

    private void runAndVerify_FullRun() {
        exchange = policyTemplate.send(exchange);
        Assertions.assertNull(exchange.getException());

        // Check to make sure we hit (or didn't hit) the expected endpoints
        Assertions.assertNotNull(exchange.getMessage().getHeader("unitTestBodyBarcodeRetrieve"));
        Assertions.assertNotNull(exchange.getMessage().getHeader("unitTestBodyDmnGovIdBarcode"));
        Assertions.assertNotNull(exchange.getMessage().getHeader("unitTestBodyDmnAccountLookup"));
        Assertions.assertNotNull(exchange.getMessage().getHeader("unitTestBodyMatching"));
        Assertions.assertNotNull(exchange.getMessage().getHeader("unitTestBodyDmnMatchingStatusCheck"));
    }

    private void runAndVerify_StopAfterDMNGovIDBarcode() {
        exchange = policyTemplate.send(exchange);
        Assertions.assertNull(exchange.getException());

        // Check to make sure we hit (or didn't hit) the expected endpoints
        Assertions.assertNotNull(exchange.getMessage().getHeader("unitTestBodyBarcodeRetrieve"));
        Assertions.assertNotNull(exchange.getMessage().getHeader("unitTestBodyDmnGovIdBarcode"));
        Assertions.assertNull(exchange.getMessage().getHeader("unitTestBodyDmnAccountLookup"));
        Assertions.assertNull(exchange.getMessage().getHeader("unitTestBodyMatching"));
        Assertions.assertNull(exchange.getMessage().getHeader("unitTestBodyDmnMatchingStatusCheck"));
    }

    private void runAndVerify_BarcodeRetrieveException() {
        exchange = policyTemplate.send(exchange);
        Assertions.assertNotNull(exchange.getException());

        // Check to make sure we hit (or didn't hit) the expected endpoints
        Assertions.assertNotNull(exchange.getMessage().getHeader("unitTestBodyBarcodeRetrieve"));
        Assertions.assertNull(exchange.getMessage().getHeader("unitTestBodyDmnGovIdBarcode"));
        Assertions.assertNull(exchange.getMessage().getHeader("unitTestBodyDmnAccountLookup"));
        Assertions.assertNull(exchange.getMessage().getHeader("unitTestBodyMatching"));
        Assertions.assertNull(exchange.getMessage().getHeader("unitTestBodyDmnMatchingStatusCheck"));
    }

    private void runAndVerify_MatchingException() {
        exchange = policyTemplate.send(exchange);
        Assertions.assertNull(exchange.getException());

        // Check to make sure we hit (or didn't hit) the expected endpoints
        Assertions.assertNotNull(exchange.getMessage().getHeader("unitTestBodyBarcodeRetrieve"));
        Assertions.assertNotNull(exchange.getMessage().getHeader("unitTestBodyDmnGovIdBarcode"));
        Assertions.assertNotNull(exchange.getMessage().getHeader("unitTestBodyDmnAccountLookup"));
        Assertions.assertNotNull(exchange.getMessage().getHeader("unitTestBodyMatching"));
        Assertions.assertNull(exchange.getMessage().getHeader("unitTestBodyDmnMatchingStatusCheck"));
    }

    private void checkInitialSetup(String customerReferenceIds) {
        Assertions.assertTrue(exchange.getProperty("customerReferenceIds").toString().contains(customerReferenceIds));
    }

    private void checkValuesPassedTo_BarcodeRetrieve() {
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyBarcodeRetrieve").toString().contains("barcode=" + post_barcode));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyBarcodeRetrieve").toString().contains("businessUnit=" + post_businessUnit));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyBarcodeRetrieve").toString().contains("configId=" + post_configId));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyBarcodeRetrieve").toString().contains("copyText=" + post_copyText));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyBarcodeRetrieve").toString().contains("deviceId=" + post_deviceId));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyBarcodeRetrieve").toString().contains("location=" + post_location));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyBarcodeRetrieve").toString().contains("model=" + post_model));
    }

    private void checkProperties_AfterBarcodeRetrieve(barcodeRetrievePropertiesToggle dateToggle) {
        Assertions.assertTrue(exchange.getProperty("documentReferenceId").toString().contains(barcodeRetrieve_referenceId));

        switch(dateToggle) {
            case GOOD_DATES:
                Assertions.assertTrue(exchange.getProperty("issueStateCode").toString().contains(barcodeRetrieve_issueStateCode));
                Assertions.assertTrue(exchange.getProperty("expirationDate").toString().contains(barcodeRetrieve_expirationDate));
                break;
            case NULL_FIELDS:
                Assertions.assertNull(exchange.getProperty("issueStateCode"));
                Assertions.assertNull(exchange.getProperty("expirationDate"));
                break;
            case NULL_DATES:
                Assertions.assertTrue(exchange.getProperty("issueStateCode").toString().contains(barcodeRetrieve_issueStateCode));
                Assertions.assertNull(exchange.getProperty("expirationDate"));

                break;
            case BAD_DATES:
                Assertions.assertTrue(exchange.getProperty("issueStateCode").toString().contains(barcodeRetrieve_issueStateCode));
                Assertions.assertTrue(exchange.getProperty("expirationDate").toString().contains(barcodeRetrieve_badDate));
                break;
        }
    }

    private void checkDates(String dateStatus) {
        Assertions.assertTrue(exchange.getProperty("expirationDateValid").toString().contains(dateStatus));
    }

    private void checkValuesPassedTo_DMNGovIdBarcode(String documentStatus, String issueStateCode) {
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyDmnGovIdBarcode").toString().contains("brTransactionName=account_lookup_1.3_GovIdBarcode.dmn"));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyDmnGovIdBarcode").toString().contains("clientConfigId=null"));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyDmnGovIdBarcode").toString().contains("documentStatus=" + documentStatus));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyDmnGovIdBarcode").toString().contains("issueStateCode=" + issueStateCode));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyDmnGovIdBarcode").toString().contains("brDecisionOutputname=LookupRouting"));
    }

    private void checkValuesPassedTo_DMNAccountLookup(String dmnType, String expirationDate) {
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyDmnAccountLookup").toString().contains("brTransactionName=account_lookup_1.3_AccountLookup" + dmnType + ".dmn"));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyDmnAccountLookup").toString().contains("documentExpirationDate=" + expirationDate));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyDmnAccountLookup").toString().contains("documentExpirationDateValid=" + exchange.getProperty("expirationDateValid").toString()));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyDmnAccountLookup").toString().contains("brDecisionOutputname=decisionResult"));
    }

    private void checkValuesPassedTo_Matching(String governmentDocumentId, String customerReferenceId) {
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyMatching").toString().contains("governmentDocumentId=" + governmentDocumentId));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyMatching").toString().contains("customerReferenceId=" + customerReferenceId));
    }

    private void checkValuesPassedTo_DMNMatchingStatusCheck(String customerReferenceId, String issueStateCode) {
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyDmnMatchingStatusCheck").toString().contains("brTransactionName=account_lookup_1.3_MatchingStatusCheck.dmn"));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyDmnMatchingStatusCheck").toString().contains("customerReferenceId=" + customerReferenceId));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyDmnMatchingStatusCheck").toString().contains("firstNameScore=" + matching_firstNameScore));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyDmnMatchingStatusCheck").toString().contains("lastNameScore=" + matching_lastNameScore));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyDmnMatchingStatusCheck").toString().contains("dateOfBirthScore=" + matching_dateOfBirthScore));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyDmnMatchingStatusCheck").toString().contains("issueStateCode=" + issueStateCode));
        Assertions.assertTrue(exchange.getMessage().getHeader("unitTestBodyDmnMatchingStatusCheck").toString().contains("brDecisionOutputname=MatchingResult"));
    }

    private void checkFinalValues_FullRun() {
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("customerReferenceId=" + matching_customerReferenceId));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("customerMatchStatus=" + matchingStatusCheck_customerMatchStatus));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("matchFailureReason=" + matchingStatusCheck_matchFailureReason));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("documentValidityStatus=" + accountLookup_documentValidityStatus));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("documentFailureReason=" + accountLookup_documentFailureReason));
    }

    private void checkFinalValues_FullRun_TwoCustomers() {
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("customerReferenceId=" + post_customerReferenceIdA));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("customerMatchStatus=" + matchingStatusCheck_customerMatchStatus));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("matchFailureReason=" + matchingStatusCheck_matchFailureReason));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("customerReferenceId=" + post_customerReferenceIdB));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("customerMatchStatus=" + matchingStatusCheck_customerMatchStatusB));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("matchFailureReason=" + matchingStatusCheck_matchFailureReasonB));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("documentValidityStatus=" + accountLookup_documentValidityStatus));
        Assertions.assertTrue(exchange.getMessage().getBody().toString().contains("documentFailureReason=" + accountLookup_documentFailureReason));
    }

    public void testOneCustomer_FullRun(String route, String dmnType, barcodeRetrievePropertiesToggle dateType) throws IOException {

        switch (dateType) {
            case GOOD_DATES:
                createBarcodeRetrieveMock(barcodeRetrieveResponse(barcodeRetrieveResponses.FOUND_ID, barcodeRetrieve_expirationDate));
                break;
            case BAD_DATES:
                createBarcodeRetrieveMock(barcodeRetrieveResponse(barcodeRetrieveResponses.FOUND_ID, barcodeRetrieve_badDate));
                break;
            case NULL_DATES:
                createBarcodeRetrieveMock(barcodeRetrieveResponse(barcodeRetrieveResponses.NULL_DATES, null));
                break;
        }

        createDmnGovIdBarcodeMock(dmnGovIdBarcodeResponse(route));
        createDmnAccountLookupMock(dmnAccountLookupResponse());
        createMatchingMock(matchingResponse(matchingResponse.GOOD_MATCH, matching_customerReferenceId));
        createDmnMatchingStatusCheckMock(dmnMatchingStatusCheckResponse(matchingStatusCheck_customerMatchStatus, matchingStatusCheck_matchFailureReason));

        runAndVerify_FullRun();

        // Check to make sure the right data was passed to the endpoints and that the right values were stored
        // in the properties
        checkInitialSetup(post_customerReferenceIdA);
        checkValuesPassedTo_BarcodeRetrieve();
        checkValuesPassedTo_DMNGovIdBarcode(barcodeRetrieve_documentStatus, barcodeRetrieve_issueStateCode);
        Assertions.assertTrue(exchange.getProperty("dmn").toString().contains(dmnType));
        checkValuesPassedTo_Matching(barcodeRetrieve_referenceId, post_customerReferenceIdA);
        checkValuesPassedTo_DMNMatchingStatusCheck(matching_customerReferenceId, barcodeRetrieve_issueStateCode);

        switch (dateType) {
            case GOOD_DATES:
                checkProperties_AfterBarcodeRetrieve(barcodeRetrievePropertiesToggle.GOOD_DATES);
                checkDates(dateValid);
                checkValuesPassedTo_DMNAccountLookup(dmnType, barcodeRetrieve_expirationDate);
                break;
            case BAD_DATES:
                checkProperties_AfterBarcodeRetrieve(barcodeRetrievePropertiesToggle.BAD_DATES);
                checkDates(dateINVALID);
                checkValuesPassedTo_DMNAccountLookup(dmnType, barcodeRetrieve_badDate);
                break;
            case NULL_DATES:
                checkProperties_AfterBarcodeRetrieve(barcodeRetrievePropertiesToggle.NULL_DATES);
                checkDates(dateNULL);
                checkValuesPassedTo_DMNAccountLookup(dmnType, null);
                break;
        }

        // Make sure it has the expected values in the final body
        checkFinalValues_FullRun();
    }
}