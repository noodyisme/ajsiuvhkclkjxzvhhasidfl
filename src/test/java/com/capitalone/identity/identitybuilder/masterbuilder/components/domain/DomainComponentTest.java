package com.capitalone.identity.identitybuilder.masterbuilder.components.domain;

import com.capitalone.identity.identitybuilder.verification.CamelContextTestUtil;
import org.apache.camel.CamelContext;
import org.apache.camel.test.junit5.CamelTestSupport;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import com.capitalone.utils.CamelSpringBootContextAwareTest;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;


@CamelSpringBootContextAwareTest(
        contextConfigClasses = DomainComponentTest.ContextConfig.class,
        excludeFromComponentScan = @ComponentScan.Filter(type = FilterType.ASPECTJ,
                pattern = "com.capitalone.dsd.identity.masterbuilder.camel.components.domain.*"))
public class DomainComponentTest extends CamelTestSupport {
	private static final String DOMAIN = "domainName";
	private static final String POLICY_NAME = "policyName";
	private static final String POLICY_VERSION = "2.3";
    private static final String METHOD = "post";
    private static final String DX_VERSION = "3.3";
    private static final String UNWRAP = "true";
    private static final String STRINGIFY = "false";
    
    private static final String PATH = "/" + DOMAIN + "/" + POLICY_NAME + "/" + POLICY_VERSION;
    private static final String FULL_URI = "domain:" + PATH;

    private static DomainComponent component;

    @BeforeAll
    public static void setComponents() {
        component = new DomainComponent();
    }

    @Test
    public void testWithParameters() throws Exception {
    	// Example parameters:
    	// uri= dx://deviceConfidence:https://heimstubs-api-ite.clouddqt.capitalone.com/heimstubs-web/identity/profiles/enhanced-validation?dxVersion=3
    	// remaining= deviceConfidence:https://heimstubs-api-ite.clouddqt.capitalone.com/heimstubs-web/identity/profiles/enhanced-validation
    	
    	// Extra parameters not known to the endpont.
    	Map<String, Object> extraParameters = new HashMap<>(); 
    	extraParameters.put("bogusParam1", "bogusValue1");
    	extraParameters.put("bogusParam2", "bogusValue2");
    	
    	// All the parameters passed to the endpoint
    	Map<String, Object> parameters = new HashMap<>();
    	parameters.put("method", METHOD);
    	parameters.put("dxVersion", DX_VERSION);
    	parameters.put("unwrap", UNWRAP);
    	parameters.put("stringify", STRINGIFY);
    	parameters.putAll(extraParameters);

    	DomainEndpoint endpoint = (DomainEndpoint) component.createEndpoint(FULL_URI, PATH, parameters);
    	
    	Assertions.assertSame(component, endpoint.getComponent());
    	Assertions.assertEquals(DOMAIN, endpoint.getDomain());
    	Assertions.assertEquals(DX_VERSION, endpoint.getDxVersion());
    	Assertions.assertSame(FULL_URI, endpoint.getEndpointUri());
    	Assertions.assertSame(parameters, endpoint.getParameters());
    	Assertions.assertSame(METHOD, endpoint.getMethod());
    	Assertions.assertEquals(POLICY_NAME, endpoint.getPolicyName());
    	Assertions.assertEquals(POLICY_VERSION, endpoint.getPolicyVersion());
    }
    
    @Test
    public void testInvalidPath() {
        Assertions.assertThrows(IllegalArgumentException.class, () ->
                component.createEndpoint("domain://foo/1.0", "//foo/1.0", Collections.emptyMap()));
    }

    @Configuration
    public static class ContextConfig {

        @Bean
        protected CamelContext createCamelContext() {
            CamelContext camelContext = CamelContextTestUtil.createDefaultCamelContext();
            camelContext.addComponent("domain", component);
            return camelContext;
        }
    }
}