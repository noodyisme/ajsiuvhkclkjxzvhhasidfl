package com.capitalone.identity.identitybuilder.verification.config;

import java.util.Set;

import com.capitalone.identity.identitybuilder.masterbuilder.api.v2.JourneyResource;
import org.glassfish.jersey.jackson.JacksonFeature;

import com.capitalone.identity.identitybuilder.masterbuilder.config.ResourceConfig;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class ResourceConfigTest {

    @Test
    public final void testResourceConfig() {
        ResourceConfig resourceConfig = new ResourceConfig();
        Set<Class<?>> resourceConfigClasses = resourceConfig.getClasses();
        Assertions.assertTrue(resourceConfigClasses.contains(JourneyResource.class));
        Assertions.assertTrue(resourceConfigClasses.contains(JacksonFeature.class));
    }
}
