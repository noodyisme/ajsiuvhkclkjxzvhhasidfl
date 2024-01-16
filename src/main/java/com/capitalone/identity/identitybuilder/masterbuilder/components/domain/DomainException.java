package com.capitalone.identity.identitybuilder.masterbuilder.components.domain;

import com.capitalone.identity.identitybuilder.policycore.service.exception.DownstreamException;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Map;

/**
 * Represents an error returned from a downstream domain API call
 * invoked through DevExchange.
 *
 * @author oqu271
 */
@Getter
@AllArgsConstructor
public class DomainException extends DownstreamException {
    private static final long serialVersionUID = -432258262512444723L;

    private final transient String domain;
    private final transient String policyName;
    private final transient String policyVersion;
    private final transient String method;
    private final transient Map<String, Object> body;

    @Override
    public String toString() {
        return "The %s domain policy \"%s\" version \"%s\" (%s method) returned the following error \"%s\"".formatted(
            domain, policyName, policyVersion, method,
            body.toString()); //TODO format as JSON?
    }

    @Override
    public Map<String, Object> getBody() {
        return body;
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