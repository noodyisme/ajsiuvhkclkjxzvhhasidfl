package com.capitalone.identity.identitybuilder.masterbuilder.components.domain;

import org.apache.camel.*;
import org.apache.camel.spi.Metadata;
import org.apache.camel.spi.UriEndpoint;
import org.apache.camel.spi.UriParam;
import org.apache.camel.spi.UriPath;
import org.apache.camel.support.DefaultEndpoint;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

import java.util.Map;

@Getter
@Setter
@EqualsAndHashCode(callSuper=true)
/**
 * Defines a target endpoint for the Domain component.
 * <p>
 * This class holds the path fields and query option values and also creates
 * new Producers.
 * 
 * @author oqu271
 */
@UriEndpoint(
    scheme = "domain",
    title = "Domain",
    syntax="domain:/domainName/policyName/policyVersion?<options...>")
public class DomainEndpoint extends DefaultEndpoint {
	@UriPath(label = "common") @Metadata(required = true)
    private String domain;
    @UriPath(label = "common")
    private String policyName;
    @UriPath(label = "common")
    private String policyVersion;

    @UriParam(label = "common", enums = "get,post", defaultValue = "post")
    private String method = "post";
    @UriParam(label = "common", defaultValue = "1")
    private String dxVersion = "1";
	@UriParam(label = "common", defaultValue = "true")
	private boolean unwrap = true;
    @UriParam(label = "common", defaultValue = "false")
    private boolean stringify = false;

    private Map<String, Object> parameters;

    public DomainEndpoint(String uri, DomainComponent component) {
        super(uri, component);
    }

    /**
     * This is overridden to avoid searching the registry for a {@link org.apache.camel.spi.RestProducerFactory}.
     * We only care about configuring our custom {@link Producer}.
     * 
     * @return a configured {@link DomainProducer}
     * @throws Exception
     */
    @Override
    public Producer createProducer() throws Exception {
        return new DomainProducer(this);
    }

    @Override
    public DomainComponent getComponent() {
        return (DomainComponent) super.getComponent();
    }

    /**
     * We're not as interested in the Consumer side of things so we'll override this method
     * to do nothing except throw an exception if we try to use it as a consumer.
     * 
     * @param processor
     * @throws UnsupportedOperationException this component does not support a consumer
     */
    @Override
    public Consumer createConsumer(Processor processor) {
        throw new UnsupportedOperationException("The domain endpoint doesn't support consumers.");
    }

    @Override
    public boolean isSingleton() {
        return true;
    }
    
    @Override
    public boolean isLenientProperties() {
    	return false;
    }
}

/*
 * Copyright 2018 Capital One Financial Corporation All Rights Reserved.
 *
 * This software contains valuable trade secrets and proprietary information of
 * Capital One and is protected by law. It may not be copied or distributed in
 * any form or medium, disclosed to third parties, reverse engineered or used in
 * any manner without prior written authorization from Capital One.
 */