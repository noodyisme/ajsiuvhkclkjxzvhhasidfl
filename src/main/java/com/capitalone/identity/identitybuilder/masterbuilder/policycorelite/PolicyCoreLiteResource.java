package com.capitalone.identity.identitybuilder.masterbuilder.policycorelite;


import com.capitalone.chassis.engine.model.exception.ChassisErrorCode;
import com.capitalone.identity.platform.implementation.configuration.ConfigurationPolicyRequest;
import com.capitalone.identity.platform.implementation.configuration.ConfigurationPolicyResponse;
import com.capitalone.identity.platform.sdk.loading.PolicyLoadManager;
import com.capitalone.identity.platform.sdk.runtime.*;
import io.swagger.annotations.Api;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.inject.Inject;
import javax.ws.rs.*;
import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

@ConditionalOnProperty(value=PolicyCoreLiteConfigStore.POLICY_CORE_LITE_RESOURCE_ENABLED)
@Path("/masterbuilder-2-0-web/identity/policy-core-lite")
@Api(value = "/masterbuilder-2-0-web/identity/policy-core-lite")
public class PolicyCoreLiteResource implements PolicyResultHandler<ConfigurationPolicyResponse, ResponseEntity<Map<String, Serializable>>> {

    private final PolicyLoadManager loadManager;

    private final PolicyInvoker<ConfigurationPolicyRequest, ConfigurationPolicyResponse> policyInvoker;

    @Inject
    public PolicyCoreLiteResource(PolicyCoreLiteConfigStore store) {
        policyInvoker = new PolicyInvoker<>(store.getRuntimeContext(), store.getVersionService());
        loadManager = store.getLoadManager();
    }

    @PostConstruct
    void doStart() {
        if (!loadManager.isInitialized()) loadManager.initialize();
    }

    @PreDestroy
    void doStop() {
        loadManager.stop();
    }

    @GET
    @Path("/health")
    public ResponseEntity<Map<String, Serializable>> getHealthCheck() {
        if (!loadManager.isInitialized()) {
            return ResponseEntity.status(HttpStatus.FAILED_DEPENDENCY).build();
        }
        return ResponseEntity.status(HttpStatus.OK).build();
    }


    @POST
    @Path("/invoke/{policyAddress}/{policyVersion}")
    public ResponseEntity<Map<String, Serializable>> postResponse(@PathParam("policyAddress") String policyAddress,
                                                                  @PathParam("policyVersion") String policyVersion,
                                                                  @HeaderParam("Business-Event") String businessEvent) {
        return policyInvoker.invoke(
                policyAddress,
                policyVersion,
                new ConfigurationPolicyRequest(businessEvent), this);
    }

    @Override
    public ResponseEntity<Map<String, Serializable>> createResponseForMissingPolicy(String requestAddress, String requestVersion) {
        Map<String, Serializable> bodyMap = new HashMap<>();
        bodyMap.put("id", ChassisErrorCode.NOT_FOUND);
        bodyMap.put("text", "Policy not found");
        bodyMap.put("developerText", "Policy not found [request address=%s, request version=%s]".formatted(requestAddress, requestVersion));
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(bodyMap);
    }

    @Override
    public ResponseEntity<Map<String, Serializable>> createSuccessResponse(PolicyRequestInfo requestInfo, ConfigurationPolicyResponse policyInvocationResult) {
        Map<String, Serializable> okContent = policyInvocationResult.getContent();
        Map<String, Serializable> returnContent = new HashMap<>(okContent);
        returnContent.put("PolicyStatus", PolicyResultStatus.SUCCESS);
        return ResponseEntity.ok(returnContent);
    }

    @Override
    public ResponseEntity<Map<String, Serializable>> createErrorResponse(PolicyRequestInfo requestInfo, PolicyErrorInfo errorInfo) {
        Map<String, Serializable> error = new HashMap<>();
        error.put("id", errorInfo.getId());
        error.put("text", errorInfo.getText());
        switch (errorInfo.getError()) {
            case BAD_REQUEST_PARAMETER_RESERVED_PREFIX:
            case BAD_REQUEST_MISSING_DMN_FILE:
                return ResponseEntity.badRequest().body(error);
            case POLICY_EXECUTION_ERROR:
            default:
                error.put("PolicyStatus", PolicyResultStatus.FAILURE);
                return ResponseEntity.ok(error);
        }
    }
}
