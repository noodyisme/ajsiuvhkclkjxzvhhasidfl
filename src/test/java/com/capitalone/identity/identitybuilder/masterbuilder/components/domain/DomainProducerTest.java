package com.capitalone.identity.identitybuilder.masterbuilder.components.domain;

import com.capitalone.identity.identitybuilder.policycore.camel.PolicyConstants;
import com.capitalone.identity.identitybuilder.policycore.camel.util.PathMap;
import com.capitalone.identity.identitybuilder.policycore.model.PolicyStatus;
import com.capitalone.identity.identitybuilder.policycore.service.constants.ApplicationConstants;
import com.capitalone.identity.identitybuilder.verification.CamelContextTestUtil;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NonNull;

import org.apache.camel.*;
import org.apache.camel.support.DefaultExchange;
import org.apache.camel.test.junit5.CamelTestSupport;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentMatchers;
import org.mockito.Mockito;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;
import org.springframework.context.annotation.Configuration;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.context.TestPropertySource;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class DomainProducerTest extends CamelTestSupport {

  private static final String DOMAIN = "domainName";
  private static final String POLICY_NAME = "policyName";
  private static final String POLICY_VERSION = "2.3";
  private static final String METHOD = "post";
  private static final String DX_VERSION = "1";

  private static final String HEADER_URI_SAVE = "uriSave";

  private static final String DX_URI = "dx:%s-%s-%s:{{env.gatewayURL}}/private/189898/identity/domain/services/execute/%s/%s?method=%s&dxVersion=%s".formatted(
      DOMAIN, POLICY_NAME, POLICY_VERSION, POLICY_NAME, POLICY_VERSION, METHOD, 1);

  private static final String DOMAIN_URI = "domain:/" + DOMAIN + "/" + POLICY_NAME + "/" +  POLICY_VERSION;

  private static final Map<String, Object> ERROR_404 = new PathMap(new HashMap<>());
  static {
    ERROR_404.put("id", "200001");
    ERROR_404.put("text", "Our system experienced an error. Please try again later.");
    ERROR_404.put("actions", new ArrayList<>());
    ERROR_404.put("developerText", "Requested resource not found");
    ERROR_404.put("errorDetails.id", "200001");
    ERROR_404.put("errorDetails.text", null);
    ERROR_404.put("errorDetails.developerText", "Unknown policy \"foo/1.0\"");
  }

  private static final Map<String, Object> DOMAIN_SCHEMA_ERROR = new PathMap(new HashMap<>());
  static {
    DOMAIN_SCHEMA_ERROR.put("id", "0");
    DOMAIN_SCHEMA_ERROR.put("text", "Schema Validation Failure");
    DOMAIN_SCHEMA_ERROR.put("developerText", "[some schema validation error text]");
  }

  private static final Map<String, Object> DOMAIN_DOWNSTREAM_ERROR = new HashMap<>();
  static {
    DOMAIN_DOWNSTREAM_ERROR.put("id", "202020");
    DOMAIN_DOWNSTREAM_ERROR.put("text", "Downstream API error");
    DOMAIN_DOWNSTREAM_ERROR.put("developerText", "Downstream API \"verify-users\" returned 400: body=\"{\"id\":\"200000\",\"text\":\"An error occurred unmarshalling the user Request\",\"developerText\":\"An error occurred unmarshalling the user Request\",\"errorDetails\":{\"sequenceNumber\":0,\"invalidAttributes\":null}}");
  }
  private static final String CUSTOMER_IP = "customer-ip-addr-value";
  private static final String REQUEST_BODY_STRING = "{\"foo\": \"bar\"}";
  private static final Map<String, Object> DX_RESPONSE_BODY = Map.of("foox", "barx");
  
  @SuppressWarnings("serial")
  private Map<String, Object> HEADERS = new HashMap<>() {{
    put(PolicyConstants.HEADER_DXHEADERS, new HashMap<String, String>() {{
      put(ApplicationConstants.CUSTOMER_IP_ADDR, CUSTOMER_IP);
      put(ApplicationConstants.CHANNEL_TYPE, "mobileweb");
      put("DXHeader1", "DXHeader1-value");
      put("DXHeader2", "DXHeader2-value");
    }});
  }};

  @Test
  @DirtiesContext
  public void testNoQueryParameters() {
    // Build and set the result from the call to the dx component.
    Mockito.doAnswer(new TemplateAnswer(PolicyStatus.SUCCESS, 200, DX_RESPONSE_BODY, null, null))
        .when(template).send(ArgumentMatchers.anyString(), ArgumentMatchers.any(Exchange.class));

    Exchange exchange = new DefaultExchange(context);
    exchange.getIn().setBody(REQUEST_BODY_STRING);
    exchange.getIn().setHeaders(HEADERS);
    template.send(DOMAIN_URI, exchange);

    Assertions.assertNull(exchange.getException());
    Assertions.assertEquals(DX_URI, exchange.getIn().getHeader(HEADER_URI_SAVE));
    Assertions.assertEquals(DX_RESPONSE_BODY, exchange.getIn().getBody());
    Assertions.assertEquals(DOMAIN, exchange.getIn().getHeader(PolicyConstants.HEADER_CUSTOMHEADERS, Map.class).get("x-upstream-env"));
  }

  @Test
  @DirtiesContext
  public void testGet() {
    // Build and set the result from the call to the dx component.
    Mockito.doAnswer(new TemplateAnswer(PolicyStatus.SUCCESS, 200, DX_RESPONSE_BODY, null, null))
        .when(template).send(ArgumentMatchers.anyString(), ArgumentMatchers.any(Exchange.class));

    Exchange exchange = new DefaultExchange(context);
    exchange.getIn().setBody(REQUEST_BODY_STRING);
    exchange.getIn().setHeaders(HEADERS);
    template.send(DOMAIN_URI + "?method=get", exchange);

    Assertions.assertNull(exchange.getException());
    Assertions.assertEquals(DX_URI.replace("method=post", "method=get"), exchange.getIn().getHeader(HEADER_URI_SAVE));
    Assertions.assertEquals(DX_RESPONSE_BODY, exchange.getIn().getBody());
    Assertions.assertEquals(DOMAIN, exchange.getIn().getHeader(PolicyConstants.HEADER_CUSTOMHEADERS, Map.class).get("x-upstream-env"));
  }

  @Test
  @DirtiesContext
  public void testSpecificDxVersion() {
    // Build and set the result from the call to the dx component.
    Mockito.doAnswer(new TemplateAnswer(PolicyStatus.SUCCESS, 200, DX_RESPONSE_BODY, null, null))
        .when(template).send(ArgumentMatchers.anyString(), ArgumentMatchers.any(Exchange.class));

    Exchange exchange = new DefaultExchange(context);
    exchange.getIn().setBody(REQUEST_BODY_STRING);
    exchange.getIn().setHeaders(HEADERS);
    template.send(DOMAIN_URI+ "?dxVersion=" + DX_VERSION, exchange);

    Assertions.assertNull(exchange.getException());
    Assertions.assertEquals(DX_URI.replace("dxVersion=1", "dxVersion=" + DX_VERSION), exchange.getIn().getHeader(HEADER_URI_SAVE));
    Assertions.assertEquals(DX_RESPONSE_BODY, exchange.getIn().getBody());
    Assertions.assertEquals(DOMAIN, exchange.getIn().getHeader(PolicyConstants.HEADER_CUSTOMHEADERS, Map.class).get("x-upstream-env"));
  }

  @Test
  @DirtiesContext
  public void testStringify() {
    // Build and set the result from the call to the dx component.
    Mockito.doAnswer(new TemplateAnswer(PolicyStatus.SUCCESS, 200, DX_RESPONSE_BODY, null, null))
        .when(template).send(ArgumentMatchers.anyString(), ArgumentMatchers.any(Exchange.class));

    Exchange exchange = new DefaultExchange(context);
    exchange.getIn().setBody(REQUEST_BODY_STRING);
    exchange.getIn().setHeaders(HEADERS);
    template.send(DOMAIN_URI+ "?stringify=true", exchange);

    Assertions.assertNull(exchange.getException());
    Assertions.assertEquals(DX_URI.replace("dxVersion=1", "dxVersion=" + DX_VERSION), exchange.getIn().getHeader(HEADER_URI_SAVE));
    Assertions.assertEquals("{\"foox\":\"barx\"}", exchange.getIn().getBody());
    Assertions.assertEquals(DOMAIN, exchange.getIn().getHeader(PolicyConstants.HEADER_CUSTOMHEADERS, Map.class).get("x-upstream-env"));
  }

  @Test
  @DirtiesContext
  public void testNoUnwrap() {
    // Without unwrap we should see the full response from the DX call.
    Map<String, Object> responseBody = new HashMap<>();
    responseBody.put("policyStatus", PolicyStatus.SUCCESS.toString());
    responseBody.put("results", DX_RESPONSE_BODY);

    // Build and set the result from the call to the dx component.
    Mockito.doAnswer(new TemplateAnswer(PolicyStatus.SUCCESS, 200, DX_RESPONSE_BODY, null, null))
        .when(template).send(ArgumentMatchers.anyString(), ArgumentMatchers.any(Exchange.class));

    Exchange exchange = new DefaultExchange(context);
    exchange.getIn().setBody(REQUEST_BODY_STRING);
    exchange.getIn().setHeaders(HEADERS);
    template.send(DOMAIN_URI + "?unwrap=false", exchange);

    Assertions.assertNull(exchange.getException());
    Assertions.assertEquals(DX_URI.replace("dxVersion=1", "dxVersion=" + DX_VERSION), exchange.getIn().getHeader(HEADER_URI_SAVE));
    Assertions.assertEquals(responseBody, exchange.getIn().getBody());
    Assertions.assertEquals(DOMAIN, exchange.getIn().getHeader(PolicyConstants.HEADER_CUSTOMHEADERS, Map.class).get("x-upstream-env"));
  }

  @Test
  @DirtiesContext
  public void testUnsupportedMethod() {
    // Build and set the result from the call to the dx component.
    Mockito.doAnswer(new TemplateAnswer(PolicyStatus.SUCCESS, 200, DX_RESPONSE_BODY, null, null))
        .when(template).send(ArgumentMatchers.anyString(), ArgumentMatchers.any(Exchange.class));

    Exchange exchange = new DefaultExchange(context);
    exchange.getIn().setBody(REQUEST_BODY_STRING);
    exchange.getIn().setHeaders(HEADERS);
    Assertions.assertThrows(
        FailedToCreateProducerException.class, () -> { template.send(DOMAIN_URI+ "?method=put", exchange); });
  }

  @Test
  @DirtiesContext
  public void testDxThrowsException() {
    // Build and set the result from the call to the dx component.
    Exception expectedException = new IllegalStateException();
    Mockito.doAnswer(new TemplateAnswer(PolicyStatus.SUCCESS, 200, DX_RESPONSE_BODY, null, expectedException))
        .when(template).send(ArgumentMatchers.anyString(), ArgumentMatchers.any(Exchange.class));

    Exchange exchange = new DefaultExchange(context);
    exchange.getIn().setBody(REQUEST_BODY_STRING);
    exchange.getIn().setHeaders(HEADERS);
    template.send(DOMAIN_URI, exchange);

    Assertions.assertSame(expectedException, exchange.getException());
  }

  @Test
  @DirtiesContext
  public void testDomainDownstreamError() {
    Map<String, Object> expectedBody = new HashMap<>();
    expectedBody.put("errorInfo", DOMAIN_DOWNSTREAM_ERROR);
    expectedBody.put("policyStatus", PolicyStatus.FAILURE.toString());
    expectedBody.put("results", null);

    // Build and set the result from the call to the dx component.
    Mockito.doAnswer(new TemplateAnswer(PolicyStatus.FAILURE, 200, null, DOMAIN_DOWNSTREAM_ERROR, null))
        .when(template).send(ArgumentMatchers.anyString(), ArgumentMatchers.any(Exchange.class));

    Exchange exchange = new DefaultExchange(context);
    exchange.getIn().setBody(REQUEST_BODY_STRING);
    exchange.getIn().setHeaders(HEADERS);
    template.send(DOMAIN_URI, exchange);

    Assertions.assertNotNull(exchange.getException());
    Assertions.assertTrue(exchange.getException() instanceof DomainException);
    DomainException e = (DomainException) exchange.getException();
    Assertions.assertEquals(DOMAIN, e.getDomain());
    Assertions.assertEquals(METHOD, e.getMethod());
    Assertions.assertEquals(POLICY_NAME, e.getPolicyName());
    Assertions.assertEquals(POLICY_VERSION, e.getPolicyVersion());
    Assertions.assertEquals(expectedBody, e.getBody());
  }

  @Test
  @DirtiesContext
  public void testCallingDownstreamError() {
    Map<String, Object> expectedBody = new HashMap<>();
    expectedBody.put("errorInfo", ERROR_404);
    expectedBody.put("policyStatus", PolicyStatus.FAILURE.toString());
    expectedBody.put("results", null);

    // Build and set the result from the call to the dx component.
    Mockito.doAnswer(new TemplateAnswer(PolicyStatus.FAILURE, 404, null, ERROR_404, null))
        .when(template).send(ArgumentMatchers.anyString(), ArgumentMatchers.any(Exchange.class));

    Exchange exchange = new DefaultExchange(context);
    exchange.getIn().setBody(REQUEST_BODY_STRING);
    exchange.getIn().setHeaders(HEADERS);
    template.send(DOMAIN_URI, exchange);

    Assertions.assertNotNull(exchange.getException());
    Assertions.assertTrue(exchange.getException() instanceof DomainException);
    DomainException e = (DomainException) exchange.getException();
    Assertions.assertEquals(DOMAIN, e.getDomain());
    Assertions.assertEquals(METHOD, e.getMethod());
    Assertions.assertEquals(POLICY_NAME, e.getPolicyName());
    Assertions.assertEquals(POLICY_VERSION, e.getPolicyVersion());
    Assertions.assertEquals(expectedBody, e.getBody());
  }

  @Test
  @DirtiesContext
  public void testDomainSchemaValidationError() {
    Map<String, Object> expectedBody = new HashMap<>();
    expectedBody.put("errorInfo", DOMAIN_SCHEMA_ERROR);
    expectedBody.put("policyStatus", PolicyStatus.INVALID.toString());
    expectedBody.put("results", null);

    // Build and set the result from the call to the dx component.
    Mockito.doAnswer(new TemplateAnswer(PolicyStatus.INVALID, 200, null, DOMAIN_SCHEMA_ERROR, null))
        .when(template).send(ArgumentMatchers.anyString(), ArgumentMatchers.any(Exchange.class));

    Exchange exchange = new DefaultExchange(context);
    exchange.getIn().setBody(REQUEST_BODY_STRING);
    exchange.getIn().setHeaders(HEADERS);
    template.send(DOMAIN_URI, exchange);

    Assertions.assertNotNull(exchange.getException());
    Assertions.assertTrue(exchange.getException() instanceof DomainException);
    DomainException e = (DomainException) exchange.getException();
    Assertions.assertEquals(DOMAIN, e.getDomain());
    Assertions.assertEquals(METHOD, e.getMethod());
    Assertions.assertEquals(POLICY_NAME, e.getPolicyName());
    Assertions.assertEquals(POLICY_VERSION, e.getPolicyVersion());
    Assertions.assertEquals(expectedBody, e.getBody());
  }

  @Test
  @DirtiesContext
  public void testBadUri() {
    // Build and set the result from the call to the dx component.
    Mockito.doAnswer(new TemplateAnswer(PolicyStatus.SUCCESS, 200, DX_RESPONSE_BODY, null, null))
        .when(template).send(ArgumentMatchers.anyString(), ArgumentMatchers.any(Exchange.class));

    Exchange exchange = new DefaultExchange(context);
    exchange.getIn().setBody(REQUEST_BODY_STRING);
    exchange.getIn().setHeaders(HEADERS);
    Assertions.assertThrows(ResolveEndpointFailedException.class, () -> { template.send("domain:/foo//1.0", exchange); });
  }

  @Configuration
  @TestPropertySource(properties = {
      "env.gatewayURL=https://www.foo.com",
      "csc.local-debug=off"})
  public class ContextConfig {
  }

  @Override
  public CamelContext createCamelContext() {
    CamelContext camelContext = Mockito.spy(CamelContextTestUtil.createDefaultCamelContext());
    camelContext.addComponent("domain", new DomainComponent());

    // Instead of registering a dx component we will intercept the producer.send(..) call.
    // This line will cause createProducerTemplate to always return a fixed and SPY-ed template.
    // This allows individual tests to modify the template to produce different results.
    Mockito.doReturn(Mockito.spy(camelContext.createProducerTemplate())).when(camelContext).createProducerTemplate();

    return camelContext;
  }

  /**
   * A Mockito Spy <code>Answer</code> that will be used to generate test responses
   * from downstream DX invocations. Invocations of the domain component will be ignored.
   *
   * @author oqu271
   */
  @Getter
  @AllArgsConstructor
  private class TemplateAnswer implements Answer<Exchange> {
    private @NonNull PolicyStatus policyStatus;
    private int httpStatus;
    private Map<String, Object> resultBody;
    private Map<String, Object> errorInfo;
    private Exception e;

    @Override
    public Exchange answer(InvocationOnMock invocation) throws Throwable {
      String uri = invocation.getArgument(0);
      if (uri.startsWith("dx:")) {
        // If an exception is provided, throw it.
        if (e != null) {
          throw e;
        }

        Exchange exchange = invocation.getArgument(1);
        exchange.getIn().setHeader(HEADER_URI_SAVE, uri);
        exchange.getIn().setHeader(PolicyConstants.HEADER_HTTPSTATUS, httpStatus);
        exchange.setException(e);

        // Build a partial response with only the fields we care about.
        Map<String, Object> domainResponse = new HashMap<>();
        if (uri.contains("=get")) {
          domainResponse.put("policyJsonSchema", resultBody);
        } else {
          domainResponse.put("policyStatus", policyStatus.toString());
          domainResponse.put("results", resultBody);
          if (errorInfo != null) {
            domainResponse.put("errorInfo", errorInfo);
          }
        }

        exchange.getIn().setBody(domainResponse);

        if (exchange.getException() != null) {
          throw exchange.getException();
        }

        return exchange;
      }

      return (Exchange) invocation.callRealMethod();
    }
  }
}