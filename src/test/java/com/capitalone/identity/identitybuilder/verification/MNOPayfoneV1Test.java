package com.capitalone.identity.identitybuilder.verification;

import com.capitalone.identity.identitybuilder.policycore.camel.util.HeaderUtil;
import com.capitalone.utils.CamelSpringBootContextAwareTest;
import com.capitalone.utils.TestUtils;
import lombok.SneakyThrows;
import org.apache.camel.CamelContext;
import org.apache.camel.Exchange;
import org.apache.camel.ExtendedCamelContext;
import org.apache.camel.ProducerTemplate;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.mock.InterceptSendToMockEndpointStrategy;
import org.apache.camel.component.mock.MockEndpoint;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.capitalone.identity.identitybuilder.policycore.camel.PolicyConstants;
import com.capitalone.identity.identitybuilder.policycore.camel.util.ISO8601DateFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.test.annotation.DirtiesContext;

import java.io.IOException;
import java.util.*;

@CamelSpringBootContextAwareTest(contextConfigClasses = MNOPayfoneV1Test.ContextConfig.class,
    excludeFromComponentScan = @ComponentScan.Filter(type = FilterType.ASPECTJ,
        pattern = "com.capitalone.identity.identitybuilder.verification.*"))
@DirtiesContext(classMode = DirtiesContext.ClassMode.AFTER_EACH_TEST_METHOD)
public class MNOPayfoneV1Test implements PolicyTestSupportExchange {

  @Autowired
  private CamelContext camelContext;

  private static final String SCHEMA = "{\n" +
      "  \"$schema\": \"http://json-schema.org/draft/2019-09/schema#\",\n" +
      "  \"type\": \"object\",\n" +
      "  \"properties\": {\n" +
      "        \"optInMethod\": { \"type\": \"string\" },\n" +
      "        \"optInTimestamp\": { \"type\": \"string\", \"format\": \"date-time\" },\n" +
      "        \"optInId\": { \"type\": \"string\" },\n" +
      "        \"optInDuration\": { \"type\": \"string\" },\n" +
      "        \"optInUrl\": { \"type\": \"string\" },\n" +
      "        \"optInVersionId\": { \"type\": \"string\" },\n" +
      "        \"originator\": {\n" +
      "            \"type\": \"string\",\n" +
      "            \"enum\": [\n" +
      "                \"APPLYANDBUY\", \"ASSOCIATE\", \"INLANEBYOD\", \"INLANESCO\", \"KIOSK\",\n" +
      "                \"OUTOFLANEBYOD\", \"PHONE\", \"POS\", \"TABLET\", \"TEXTTOAPPLY\", \"UNS\", \"WEB\",\n" +
      "                \"POSTBOOK\", \"REALTIME\"\n" +
      "            ], \n" +
      "            \"$comment\": \"POSTBOOK and REALTIME are for post-booking, the rest are pre-booking\"\n" +
      "        },\n" +
      "        \"firstName\": { \"type\": \"string\" },\n" +
      "        \"lastName\": { \"type\": \"string\" },\n" +
      "        \"mobilePhoneNumber\": { \"type\": \"string\", \"pattern\": \"^\\\\d{10}$\" },\n" +
      "        \"addressLine1\": { \"type\": \"string\" },\n" +
      "        \"addressLine2\": { \"type\": \"string\" },\n" +
      "        \"stateCode\": { \n" +
      "            \"type\": \"string\" ,\n" +
      "            \"enum\": [\n" +
      "                \"AL\", \"AK\", \"AR\", \"AZ\", \"CA\", \"CO\", \"CT\", \"DE\", \"FL\", \"GA\",\n" +
      "                \"HI\", \"IA\", \"ID\", \"IL\", \"IN\", \"KS\", \"KY\", \"LA\", \"MA\", \"MD\",\n" +
      "                \"ME\", \"MI\", \"MN\", \"MO\", \"MS\", \"MT\", \"NC\", \"ND\", \"NE\", \"NH\",\n" +
      "                \"NJ\", \"NM\", \"NV\", \"NY\", \"OH\", \"OK\", \"OR\", \"PA\", \"RI\", \"SC\",\n" +
      "                \"SD\", \"TN\", \"TX\", \"UT\", \"VA\", \"VT\", \"WA\", \"WI\", \"WV\", \"WY\",\n" +
      "                \"AS\", \"DC\", \"GU\", \"PR\", \"VI\"\n" +
      "                ]\n" +
      "        },\n" +
      "        \"city\": { \"type\": \"string\" },\n" +
      "        \"postalCode\": { \"type\": \"string\", \"pattern\": \"^\\\\d{5}$\" },\n" +
      "        \"countryCode\": {\n" +
      "            \"type\": \"string\",\n" +
      "            \"enum\": [ \"US\", \"CA\" ],\n" +
      "             \"$comment\": \"From Locale.getISOCountries\"\n" +
      "        }\n" +
      "      },\n" +
      "      \"required\": [ \"optInMethod\", \"optInTimestamp\", \"optInDuration\", \"firstName\", \"lastName\", \"mobilePhoneNumber\", \"addressLine1\", \"stateCode\", \"city\", \"postalCode\", \"countryCode\" ]\n" +
      "    }\n" +
      "}";

  @Autowired @Qualifier("policyTemplate")
  protected ProducerTemplate policyTemplate;

  @Autowired @Qualifier("schemaTemplate")
  protected ProducerTemplate schemaTemplate;

  private Exchange exchange;
  private Map<String, Object> params;

  @BeforeEach
  public void setup() {
    params = makeParameters(true);
    exchange = policyExchange(params, null);
    camelContext.start();
  }

  /** Validate that the schema is available and unchanged. */
  @Test
  public void testSchema() throws IOException {
    exchange.getIn().setBody("");
    schemaTemplate.send(exchange);
    Assertions.assertNull(exchange.getException());
    // Compare maps so whitespace changes and ordering don't matter.
    Assertions.assertEquals(jsonToMap(SCHEMA), jsonToMap(exchange.getIn().getBody(String.class)));
  }

  /**
   * Validate that the downstream call is formatted correctly, including
   * all required and optional fields.
   */
  @Test
  public void testAllParameters() throws Exception {
    String expected = "{\"users\":\n    "
        + "[{\"userAttributes\":\n        "
        + "[{\"attributeName\":\"MobileNumber\",\"attributeValue\":\"" + params.get("mobilePhoneNumber") + "\""
        + "},{\"attributeName\":\"addressLine1\",\"attributeValue\":\"" + params.get("addressLine1") + "\""
        + "},{\"attributeName\":\"addressLine2\",\"attributeValue\":\"" + params.get("addressLine2") + "\""
        + "},{\"attributeName\":\"city\",\"attributeValue\":\"" + params.get("city") + "\""
        + "},{\"attributeName\":\"countryCode\",\"attributeValue\":\"" + params.get("countryCode") + "\""
        + "},{\"attributeName\":\"firstName\",\"attributeValue\":\"" + params.get("firstName") + "\""
        + "},{\"attributeName\":\"lastName\",\"attributeValue\":\"" + params.get("lastName") + "\""
        + "},{\"attributeName\":\"optInDuration\",\"attributeValue\":\"" + params.get("optInDuration") + "\""
        + "},{\"attributeName\":\"optInId\",\"attributeValue\":\"" + params.get("optInId") + "\""
        + "},{\"attributeName\":\"optInMethod\",\"attributeValue\":\"" + params.get("optInMethod") + "\""
        + "},{\"attributeName\":\"optInTimestamp\",\"attributeValue\":\"" + params.get("optInTimestamp") + "\""
        + "},{\"attributeName\":\"optInUrl\",\"attributeValue\":\"" + params.get("optInUrl") + "\""
        + "},{\"attributeName\":\"optInVersionId\",\"attributeValue\":\"" + params.get("optInVersionId") + "\""
        + "},{\"attributeName\":\"postalCode\",\"attributeValue\":\"" + params.get("postalCode") + "\""
        + "},{\"attributeName\":\"stateCode\",\"attributeValue\":\"" + params.get("stateCode") + "\""
        + "}\n            ],\"sequenceNumber\":1}\n "
        + "           ],\"configId\":\"dxapi.mno_payfone_detokenized.configId-value\"}";

    Assertions.assertTrue(testCommon(expected));
  }

  /**
   * Validate that the downstream call is formatted correctly when only
   * required parameters are given (e.g., make sure request is sparse).
   */
  @Test
  public void testOnlyRequiredParameters() throws Exception {
    // Remove optional parameters
    params.keySet().retainAll(makeParameters(false).keySet());

    String expected = "{\"users\":\n    "
        + "[{\"userAttributes\":\n        "
        + "[{\"attributeName\":\"MobileNumber\",\"attributeValue\":\"" + params.get("mobilePhoneNumber") + "\""
        + "},{\"attributeName\":\"addressLine1\",\"attributeValue\":\"" + params.get("addressLine1") + "\""
        + "},{\"attributeName\":\"city\",\"attributeValue\":\"" + params.get("city") + "\""
        + "},{\"attributeName\":\"countryCode\",\"attributeValue\":\"" + params.get("countryCode") + "\""
        + "},{\"attributeName\":\"firstName\",\"attributeValue\":\"" + params.get("firstName") + "\""
        + "},{\"attributeName\":\"lastName\",\"attributeValue\":\"" + params.get("lastName") + "\""
        + "},{\"attributeName\":\"optInDuration\",\"attributeValue\":\"" + params.get("optInDuration") + "\""
        + "},{\"attributeName\":\"optInMethod\",\"attributeValue\":\"" + params.get("optInMethod") + "\""
        + "},{\"attributeName\":\"optInTimestamp\",\"attributeValue\":\"" + params.get("optInTimestamp") + "\""
        + "},{\"attributeName\":\"postalCode\",\"attributeValue\":\"" + params.get("postalCode") + "\""
        + "},{\"attributeName\":\"stateCode\",\"attributeValue\":\"" + params.get("stateCode") + "\""
        + "}\n            ],\"sequenceNumber\":1}\n "
        + "           ],\"configId\":\"dxapi.mno_payfone_detokenized.configId-value\"}";

    Assertions.assertTrue(testCommon(expected));
  }

  /**
   * Performs common test invocation and checking.
   *
   * @param expected the JSON that we expect the policy to build and send downstream
   * @return true if no assertions are thrown (allows the caller to assert to avoid SonarQube warnings)
   */
  private boolean testCommon(String expected) throws InterruptedException, IOException {
    Map<String, Object> dxResult = jsonToMap("{\"foo\": \"bar\" }");

    MockEndpoint dxMockEndpoint = TestUtils.mockEndpoint(camelContext,"mock:direct:mno-payfone-v1");
    dxMockEndpoint.expectedMessageCount(1);
    dxMockEndpoint.whenAnyExchangeReceived(exchange -> {
      exchange.getIn().setHeader("unitTestBody", exchange.getIn().getBody());
      exchange.getIn().setHeader(PolicyConstants.HEADER_HTTPSTATUS, "200");
      exchange.getIn().setBody(dxResult);
    });

    exchange = policyTemplate.send(exchange);
    Assertions.assertNull(exchange.getException());
    dxMockEndpoint.assertIsSatisfied();
    Assertions.assertEquals("200", exchange.getIn().getHeader(PolicyConstants.HEADER_HTTPSTATUS, String.class));
    Assertions.assertEquals(jsonToMap(expected), jsonToMap(exchange.getIn().getHeader("unitTestBody", String.class)));
    Assertions.assertEquals(dxResult, exchange.getIn().getBody());

    return true;
  }

  private Map<String, Object> makeParameters(boolean includeOptional) {
    Map<String, Object> map = new HashMap<>();
    map.put("optInMethod", "optInMethod-value");
    map.put("optInTimestamp", new ISO8601DateFormatter().deltaMilliseconds(0));
    map.put("optInDuration", "optInDuration-value");
    map.put("firstName", "firstName-value");
    map.put("lastName", "lastName-value");
    map.put("mobilePhoneNumber", "1234567890");
    map.put("addressLine1", "addressLine1-value");
    map.put("stateCode", "VA");
    map.put("city", "McLean");
    map.put("postalCode", "12345");
    map.put("countryCode", "US");
    if (includeOptional) {
      map.put("optInId", "optInId-value");
      map.put("optInUrl", "optInUrl-value");
      map.put("optInVersionId", "optInVersionId-value");
      map.put("originator", "APPLYANDBUY");
      map.put("addressLine2", "addressLine2-value");
    }
    return map;
  }

  @Override
  public CamelContext camelContext() {
    return this.camelContext;
  }

  @Configuration
  public static class ContextConfig {

    @SneakyThrows
    @Bean
    CamelContext createCamelContext() {
      final CamelContext camelContext = CamelContextTestUtil.createDefaultCamelContext();
      CamelContextTestUtil.loadProcessXml("walmart_mno_payfone_1.0.xml", camelContext);
      camelContext.addRoutes(new RouteBuilder() {
        @Override
        public void configure() {
          from("direct:headerUtil")
              .process(exchange ->
                  new HeaderUtil().process(exchange, exchange.getIn().getHeader("arg1", String.class)));
        }
      });
      camelContext.addRoutes(new RouteBuilder() {
        @Override
        public void configure() throws Exception {
          from("direct:ISO8601DatesWithDelta")
              .process(exchange ->
                  new ISO8601DateFormatter().
                      dateWithDelta(exchange, exchange.getIn().getHeader("arg1", String.class)));
        }
      });
      camelContext.adapt(ExtendedCamelContext.class)
          .registerEndpointCallback(new InterceptSendToMockEndpointStrategy("direct:mno-payfone-v1", true));
      camelContext.getPropertiesComponent().setInitialProperties(setTestProperties());
      return camelContext;
    }

    @Bean (name = "policyTemplate")
    ProducerTemplate createPolicyProducerTemplate(final CamelContext camelContext) {
      final ProducerTemplate producerTemplate = camelContext.createProducerTemplate();
      producerTemplate.setDefaultEndpointUri("policy:walmart_mno_payfone_1.0");
      return producerTemplate;
    }

    @Bean (name = "schemaTemplate")
    ProducerTemplate createSchemaProducerTemplate(final CamelContext camelContext) {
      final ProducerTemplate producerTemplate = camelContext.createProducerTemplate();
      producerTemplate.setDefaultEndpointUri("direct:walmart_mno_payfone_1.0-schema");
      return producerTemplate;
    }

    private Properties setTestProperties() {
      Properties props = new Properties();
      props.put("dxapi.mno_payfone_detokenized.configId", "dxapi.mno_payfone_detokenized.configId-value");
      return props;
    }
  }
}
