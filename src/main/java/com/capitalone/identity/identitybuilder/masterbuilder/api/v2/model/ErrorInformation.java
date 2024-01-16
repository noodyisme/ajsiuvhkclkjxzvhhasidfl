package com.capitalone.identity.identitybuilder.masterbuilder.api.v2.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ErrorInformation implements Serializable {
    private static final long serialVersionUID = -1158204410809749457L;
    private String id;
    private String text;
    @JsonInclude(JsonInclude.Include.NON_NULL)
    private String developerText;
}
