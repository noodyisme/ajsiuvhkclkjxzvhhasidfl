package com.capitalone.identity.identitybuilder.masterbuilder.api.v2.model;

import java.util.Map;

import lombok.*;

/**
 * Metadata associated with policy. Returned by GET ../{policyName}/{policyVersion}
 */
@Data
@NoArgsConstructor
public class PolicyMetadata {
    @NonNull
    private String domain;
    @NonNull
    private String policyName;
    @NonNull
    private String policyVersion;

    private String step;
    @NonNull
    private Map<String, Object> policyJsonSchema;
    @NonNull
    private String policyContentTypeParameterString;

    public PolicyMetadata(com.capitalone.identity.identitybuilder.policycore.model.PolicyMetadata policyCoreMetadata, String contentType) {
        this.domain = policyCoreMetadata.getDomain();
        this.policyName = policyCoreMetadata.getPolicyName();
        this.policyVersion = policyCoreMetadata.getPolicyVersion();
        this.step = policyCoreMetadata.getStep();
        this.policyJsonSchema = policyCoreMetadata.getPolicyJsonSchema();
        this.policyContentTypeParameterString = contentType;
    }
}
