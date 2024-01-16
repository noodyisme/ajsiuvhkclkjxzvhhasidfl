package com.capitalone.identity.identitybuilder.masterbuilder;

import org.springframework.boot.WebApplicationType;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication(scanBasePackages = {
        "com.capitalone.identity.identitybuilder.policycore",
        "com.capitalone.dsd.utilities.crypto.lib",
        "com.capitalone.identity.identitybuilder.masterbuilder",
        "com.capitalone.dsd.elasticache"
})
@EnableScheduling
public class MasterBuilderApplication {

    public static void main(String[] args) {
        new SpringApplicationBuilder(MasterBuilderApplication.class).web(WebApplicationType.SERVLET).run(args);
    }
}

/*
 * Copyright 2020 Capital One Financial Corporation All Rights Reserved.
 *
 * This software contains valuable trade secrets and proprietary information of Capital One and is
 * protected by law. It may not be copied or distributed in any form or medium, disclosed to third
 * parties, reverse engineered or used in any manner without prior written authorization from
 * Capital One.
 */
