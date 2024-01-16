package com.capitalone.utils;

import org.apache.camel.CamelContext;
import org.apache.camel.builder.AdviceWith;
import org.apache.camel.component.mock.MockEndpoint;

/**
 * @author plz569
 *
 * Test utilities to simplify interactions with Camel Context
 */
public class TestUtils {

    public static MockEndpoint mockEndpoint(CamelContext camelContext, String mockEndpointUri) {
        return camelContext.getEndpoint(mockEndpointUri, MockEndpoint.class);
    }

    public static void mockEndpointAndSkip(CamelContext camelContext, String routeId, String mockEndpointUri) throws Exception {
        AdviceWith.adviceWith(camelContext, routeId, b ->
                b.mockEndpointsAndSkip(mockEndpointUri));
    }
}
