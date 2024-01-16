package com.capitalone.identity.identitybuilder.masterbuilder.api.v2.model;

import com.capitalone.identity.identitybuilder.policycore.model.APIResponse;
import com.capitalone.identity.identitybuilder.policycore.model.ErrorInfo;
import com.capitalone.identity.identitybuilder.policycore.model.PolicyStatus;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.*;

/**
 * Response from an executed policy (or step). Returned by POST/PATCH methods.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@RequiredArgsConstructor
public class ExecutePolicyResponse {

    @NonNull
    private Object policyResponseBody;
    @NonNull
    private PolicyStatus policyStatus;
    @JsonInclude(JsonInclude.Include.NON_NULL)
    private ErrorInformation errorInformation;
    @JsonInclude(JsonInclude.Include.NON_NULL)
    private ProcessMetadata metadata;

    public ExecutePolicyResponse(APIResponse.APISuccessResponse policyCoreResponse) {
        this.policyResponseBody = policyCoreResponse.getResults();
        this.policyStatus = policyCoreResponse.getPolicyStatus();

        ErrorInfo errorInfo = policyCoreResponse.getErrorInfo();
        if (errorInfo != null) {
            this.errorInformation = new ErrorInformation(errorInfo.getId(), errorInfo.getText(), errorInfo.getDeveloperText());
        }

        com.capitalone.identity.identitybuilder.policycore.model.ProcessMetadata policyCoreResponseMetadata = policyCoreResponse.getMetadata();
        if (policyCoreResponseMetadata != null) {
            this.metadata = new ProcessMetadata(policyCoreResponseMetadata);
        }
    }
}
