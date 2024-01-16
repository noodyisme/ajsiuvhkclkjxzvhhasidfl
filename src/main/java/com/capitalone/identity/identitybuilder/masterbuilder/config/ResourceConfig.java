package com.capitalone.identity.identitybuilder.masterbuilder.config;

import com.capitalone.chassis.engine.jersey.extensions.config.BaseResourceConfig;
import com.capitalone.identity.identitybuilder.masterbuilder.api.v2.JourneyResource;
import com.capitalone.identity.identitybuilder.masterbuilder.policycorelite.PolicyCoreLiteResource;
import com.capitalone.identity.identitybuilder.policycore.rest.v1.DelegationPatternResource;
import com.capitalone.identity.identitybuilder.policycore.rest.v1.HealthResource;
import com.capitalone.identity.identitybuilder.policycore.service.exception.mappers.JsonMappingExceptionMapper;
import com.capitalone.identity.identitybuilder.policycore.service.exception.mappers.JsonParseExceptionMapper;
import com.capitalone.identity.identitybuilder.policycore.service.exception.mappers.JsonProcessingExceptionMapper;
import org.glassfish.jersey.jackson.JacksonFeature;
import org.glassfish.jersey.media.multipart.MultiPartFeature;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ResourceConfig extends BaseResourceConfig {

    public ResourceConfig() {
        super();
        registerClasses(MultiPartFeature.class);
        registerClasses(JourneyResource.class);
        registerClasses(HealthResource.class);
        registerClasses(JacksonFeature.class);
        registerClasses(DelegationPatternResource.DomainResource.class);
        registerClasses(DelegationPatternResource.DomainFileUploadResource.class);
        registerClasses(JsonParseExceptionMapper.class,
                        JsonMappingExceptionMapper.class,
                        JsonProcessingExceptionMapper.class);
        registerClasses(PolicyCoreLiteResource.class);
    }
}

/*
 * Copyright 2020 Capital One Financial Corporation All Rights Reserved.
 *
 * This software contains valuable trade secrets and proprietary information of Capital One and is
 * protected by law. It may not be copied or distributed in any form or medium, disclosed to thirds
 * parties, reverse engineered or used in any manner without prior written authorization from
 * Capital One.
 */