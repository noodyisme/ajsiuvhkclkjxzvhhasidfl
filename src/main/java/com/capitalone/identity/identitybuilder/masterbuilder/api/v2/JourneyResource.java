package com.capitalone.identity.identitybuilder.masterbuilder.api.v2;

import com.capitalone.identity.identitybuilder.policycore.rest.v1.PublicPolicyMultistepResource;
import io.swagger.annotations.Api;

import javax.ws.rs.Consumes;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("/masterbuilder-2-0-web/identity/workflow-management")
@Api(value = "/masterbuilder-2-0-web/identity/workflow-management")
@Produces({"application/vnd.com.capitalone.api+v2+json", MediaType.APPLICATION_JSON})
@Consumes({"application/vnd.com.capitalone.api+v2+json", MediaType.APPLICATION_JSON})
public class JourneyResource extends PublicPolicyMultistepResource {
}

