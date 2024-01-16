package com.capitalone.identity.identitybuilder.masterbuilder.components.domain;

import org.apache.camel.Endpoint;
import org.apache.camel.support.DefaultComponent;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * Defines the <i>Domain</i> component that simplifies Dev Exchange calls from
 * the Journey server to domain servers.
 * <p>
 * This component invokes the {@link DevExchangeComponent} to make the actual call
 * but provides useful features to the invoking policy:
 * <p>
 * <b>Requests</b>
 * <ul>
 * <li>Uniform application name format</li>
 * <li>Complex DX component endpoint building</li>
 * <li>POST command bodies are automatically wrapped in a "policyParameters" element</li>
 * <li>Target API version support</li>
 * </ul>
 * <b>Responses</b>
 * <ul>
 * <li>Domain policy failures result in a thrown exception with additional information added</li>
 * <li>Automatic unwrapping of successful POST responses by default (optional)</li>
 * <li>Optional conversion of the response into a JSON string (used for GET pass-thru calls).</li>
 * </ul>
 * 
 * @see {@link DomainEndpoint}
 * @author oqu271
 */
public class DomainComponent extends DefaultComponent {
	// The pattern for the URI path is "/targetDomain/policyName/policyVersion"
	@SuppressWarnings("squid:S4784")
	private static final Pattern PATTERN = Pattern.compile("\\/[^/]+\\/[^/]+\\/\\d+(\\.\\d+)?");

    @Override
    protected Endpoint createEndpoint(String uri, String remaining, Map<String, Object> parameters) throws Exception {
        DomainEndpoint endpoint = new DomainEndpoint(uri, this);

        if (!PATTERN.matcher(remaining).matches()) {
        	throw new IllegalArgumentException("Invalid URI %s - must be \"domain:/<targetDomain>/<policyName>/<policyVersion>\"".formatted(uri));
        }

        String[] values = remaining.split("/");
        endpoint.setDomain(values[1]);
        endpoint.setPolicyName(values[2]);
        endpoint.setPolicyVersion(values[3]);
        setProperties(endpoint, parameters);

        endpoint.setParameters(parameters);

        return endpoint;
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
