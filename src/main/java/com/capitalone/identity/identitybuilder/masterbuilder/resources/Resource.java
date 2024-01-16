package com.capitalone.identity.identitybuilder.masterbuilder.resources;

import com.capitalone.chassis.engine.annotations.logging.Log;
import com.capitalone.chassis.engine.annotations.logging.Profile;
import org.springframework.stereotype.Component;

import javax.inject.Singleton;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Log
@Profile
@Component
@Singleton
@Path("/")
@Produces({"application/vnd.com.capitalone.api+v1+json", "application/vnd.com.capitalone.api+v1+xml", MediaType.APPLICATION_JSON})
@Consumes({"application/vnd.com.capitalone.api+v1+json", "application/vnd.com.capitalone.api+v1+xml", MediaType.APPLICATION_JSON})
public class Resource {

    @GET
    @Path("hello")
    public String sayHello() {
        return "Hello world!";
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