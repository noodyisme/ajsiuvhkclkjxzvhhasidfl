package com.capitalone.identity.identitybuilder.masterbuilder.components.domain;

import com.capitalone.chassis.engine.model.exception.ChassisBusinessException;
import com.capitalone.identity.identitybuilder.policycore.camel.PolicyConstants;
import com.capitalone.identity.identitybuilder.policycore.model.PolicyStatus;
import org.apache.camel.Endpoint;
import org.apache.camel.Exchange;
import org.apache.camel.Message;
import org.apache.camel.ProducerTemplate;
import org.apache.camel.spi.DataFormat;
import org.apache.camel.support.DefaultProducer;
import org.springframework.http.HttpMethod;
import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.*;

/**
 * The producer for the custom <i>Policy</i> component.
 * 
 * @author oqu271
 */
public class DomainProducer extends DefaultProducer {
	public static final String HEADER_CLIENT_IP = "Client-IP";
    private static final Set<HttpMethod> SUPPORTED_METHODS = new HashSet<>(
    		Arrays.asList(HttpMethod.GET, HttpMethod.POST));
    
    private DataFormat jackson;
    private HttpMethod method;

    public DomainProducer(DomainEndpoint endpoint) {
        super(endpoint);
        
        method = HttpMethod.valueOf(getEndpoint().getMethod().toUpperCase(Locale.US));
        if (!SUPPORTED_METHODS.contains(method)) {
        	throw new UnsupportedOperationException(
                "The domain endpoint only supports the following methods: %s".formatted(SUPPORTED_METHODS.toString().toLowerCase()));
        }
        
        // Find the data formatter to parse returned JSON into a Map.
        jackson = findJacksonDataFormat(endpoint);
    }

    @SuppressWarnings("unchecked")
	@Override
    public void process(Exchange exchange) throws Exception {
        DomainEndpoint endpoint = getEndpoint();
        
        String uri = String.format("dx:%s-%s-%s:{{env.gatewayURL}}/private/189898/identity/domain/services/execute/%s/%s?method=%s&dxVersion=%s",
        		endpoint.getDomain(), endpoint.getPolicyName(), endpoint.getPolicyVersion(),
        		endpoint.getPolicyName(), endpoint.getPolicyVersion(),
        		endpoint.getMethod(), endpoint.getDxVersion());
        
        Message message = exchange.getMessage();
                
        // We need to set the special header to let DevExchange know which domain to route to.
        Map<String, Object> customHeaders = message.getHeader(PolicyConstants.HEADER_CUSTOMHEADERS, HashMap::new, Map.class);
        customHeaders.put("x-upstream-env", endpoint.getDomain());
        message.setHeader(PolicyConstants.HEADER_CUSTOMHEADERS, customHeaders);
        
        // Wrap the post body in a top-level element for use by the domain policy.
        if (endpoint.getMethod().equals("post")) {
        	message.setBody(Map.of("policyParameters", message.getBody()));
        }
       
        // Send the request to the DevExchange component
        try (ProducerTemplate template = exchange.getContext().createProducerTemplate()) {
            template.send(uri, exchange);
        }

        // If the dx component reported an exception it should have thrown it as well
        // so there's no need to re-throw it here.
        
        // If the domain call failed, throw an exception with the cause.
        Map<String, Object> body = message.getBody(Map.class);
        if (body.containsKey("errorInfo") && body.containsKey("policyStatus") && !body.get("policyStatus").equals(PolicyStatus.SUCCESS.name())) {  	
        	throw new DomainException(endpoint.getDomain(), endpoint.getPolicyName(), endpoint.getPolicyVersion(),
        			endpoint.getMethod(), body);
        }
                
        // If desired, remove the domain response wrapper from the POST result.
        if (endpoint.isUnwrap()) {
        	if (endpoint.getMethod().equals("post") && body.containsKey("policyStatus") && body.get("policyStatus").equals(PolicyStatus.SUCCESS.name())) {
        		body = (Map<String, Object>) body.get("results");
        	} else if (endpoint.isUnwrap() && endpoint.getMethod().equals("get") && body.containsKey("policyJsonSchema")) {
            	body = (Map<String, Object>) body.get("policyJsonSchema");
            }
        }
        
        // Return the result map in the original message body. 
    	exchange.getIn().setBody(body);
    	
        // If desired, convert the body into a string.
		if (endpoint.isStringify()) {
			ByteArrayOutputStream os = new ByteArrayOutputStream();
			jackson.marshal(exchange, body, os);
			exchange.getIn().setBody(os.toString(StandardCharsets.UTF_8.name()));
		}
    }

	private static DataFormat findJacksonDataFormat(Endpoint endpoint) {
		DataFormat format = endpoint.getCamelContext().resolveDataFormat("jackson");
		if (format == null) {
			throw new ChassisBusinessException("Cannot unmarshal! No data format named 'jackson' found.");
		}

		return format;
	}

    @Override
    public DomainEndpoint getEndpoint() {
        return (DomainEndpoint) super.getEndpoint();
    }
}

/*
 * Copyright 2021 Capital One Financial Corporation All Rights Reserved.
 *
 * This software contains valuable trade secrets and proprietary information of
 * Capital One and is protected by law. It may not be copied or distributed in
 * any form or medium, disclosed to third parties, reverse engineered or used in
 * any manner without prior written authorization from Capital One.
 */