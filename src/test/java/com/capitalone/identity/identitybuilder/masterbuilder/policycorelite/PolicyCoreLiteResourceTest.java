package com.capitalone.identity.identitybuilder.masterbuilder.policycorelite;

import com.capitalone.chassis.engine.model.exception.ChassisErrorCode;
import com.capitalone.identity.identitybuilder.client.ConfigStoreClient;
import com.capitalone.identity.identitybuilder.client.ConfigStoreClient_ApplicationEventPublisher;
import com.capitalone.identity.identitybuilder.client.dynamic.PollingConfiguration;
import com.capitalone.identity.identitybuilder.configmanagement.MatchingStrategies;
import com.capitalone.identity.platform.implementation.configuration.ConfigPolicyRuntimeContext;
import com.capitalone.identity.platform.sdk.loading.AggregateEntityLoadListener;
import com.capitalone.identity.platform.sdk.loading.PolicyLoadManager;
import com.capitalone.identity.platform.sdk.runtime.PolicyResultStatus;
import com.capitalone.identity.platform.sdk.versioning.PolicyVersionEventListener;
import com.capitalone.identity.platform.sdk.versioning.PolicyVersionService;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.io.Serializable;
import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class PolicyCoreLiteResourceTest {

    private static ConfigPolicyRuntimeContext context;
    private PolicyCoreLiteResource policyCoreLiteResource;
    private static PolicyLoadManager loadManager;
    private static PolicyVersionService policyVersionService;

    private static final String VALID_ADDRESS = "us_consumers/sub_lob/config_only_policy";
    private static final String VALID_VERSION = "1.0";
    private static final String VALID_BUSINESS_EVENT_A = "useCase_A_valid";
    private static final String VALID_APP_LEVEL_BUSINESS_EVENT_A = "lob.channel.div.applevel_A_valid";
    private static final String VALID_EXTENDED_APP_LEVEL_BUSINESS_EVENT_A = "lob.channel.div.applevel_A_valid.extended_app_level_A_valid";
    private static final String INVALID_APP_LEVEL_BUSINESS_EVENT_B = "lob.channel.div.app_level_B_invalid";
    private static final String INVALID_EXTENDED_APP_LEVEL_BUSINESS_EVENT_B = "lob.channel.div.applevel_A_valid.extended_app_level_B_invalid";
    private static final String INVALID_BUSINESS_EVENT = "non_existing_usecase";
    private static final ResponseEntity<Map<String, Serializable>> VALID_HEALTH_CHECK = ResponseEntity.status(HttpStatus.OK).build();

    @Mock
    PolicyCoreLiteConfigStore policyCoreLiteConfigStore;

    @BeforeAll
    static void setupAll() {
        //creating PolicyLoadManager with local configstore to be used by mock PolicyLiteConfigStore
        ConfigStoreClient client = ConfigStoreClient.newLocalClient(
                "local-config-store/us_consumers",
                new PollingConfiguration(Duration.ofDays(1)),
                ConfigStoreClient_ApplicationEventPublisher.EMPTY
        );
        context = new ConfigPolicyRuntimeContext(MatchingStrategies.MATCH_ALL_NON_NULL);
        policyVersionService = new PolicyVersionService();
        AggregateEntityLoadListener publisher = new AggregateEntityLoadListener(new PolicyVersionEventListener(policyVersionService));
        loadManager = new PolicyLoadManager(context, publisher, client, false);
    }

    @BeforeEach
    void setup(){
        when(policyCoreLiteConfigStore.getLoadManager()).thenReturn(loadManager);
        when(policyCoreLiteConfigStore.getVersionService()).thenReturn(policyVersionService);
        when(policyCoreLiteConfigStore.getRuntimeContext()).thenReturn(context);
        policyCoreLiteResource = new PolicyCoreLiteResource(policyCoreLiteConfigStore);
    }

    @Test
    void testHealthCheck() {
        //Test unloaded state error
        policyCoreLiteResource.doStart();
        ResponseEntity<Map<String, Serializable>> actualResp = policyCoreLiteResource.getHealthCheck();
        assertEquals(VALID_HEALTH_CHECK, actualResp);
    }

    @ParameterizedTest
    @CsvSource({
            VALID_BUSINESS_EVENT_A + ",AAA" + ",",
            VALID_APP_LEVEL_BUSINESS_EVENT_A + ",APP" + ",",
            """
            '',\
            ZZZ\
            ,\
            """,
            INVALID_BUSINESS_EVENT + ",ZZZ" + ",",
            INVALID_APP_LEVEL_BUSINESS_EVENT_B + ",ZZZ" + ",",
            INVALID_EXTENDED_APP_LEVEL_BUSINESS_EVENT_B + ",APP" + ",",
            VALID_EXTENDED_APP_LEVEL_BUSINESS_EVENT_A + ",EXTENDED" + ",ZZZ"
    })
    void testConfigOnlyPolicyForValidAndInValidUseCases(String useCase, String resultA, String resultB) {
        policyCoreLiteResource.doStart();
        ResponseEntity<Map<String, Serializable>> actualResponse = policyCoreLiteResource.postResponse(VALID_ADDRESS, VALID_VERSION, useCase);
        Map<String, Serializable> expectedResponse = new HashMap<String, Serializable>() {
            {
                ArrayList<String> paramArray = new ArrayList<>();
                paramArray.add("AA");
                paramArray.add("BB");
                paramArray.add("CC");
                put("param-bool", false);
                put("param-array", paramArray);
                put("param-num", 0.5);
                put("param-A", resultA + "_A");
                put("param-B", resultB == null ? resultA + "_B" : resultB + "_B");
                put("param-int", 1);
                put("PolicyStatus", PolicyResultStatus.SUCCESS);
            }
        };
        assertEquals(expectedResponse, actualResponse.getBody());
    }

    //Verify request with no use case throws java.lang.NullPointerException: Parameter specified as non-null is null, parameter businessEventName
    @Test
    void testPolicyInvocationWithNoUseCase() {
        policyCoreLiteResource.doStart();
        assertThrows(NullPointerException.class, () -> policyCoreLiteResource.postResponse(VALID_ADDRESS, VALID_VERSION, null));
    }

    @ParameterizedTest
    @CsvSource({
            "XXXXXXX/YYYY/ZZZZ," + VALID_VERSION,
            VALID_ADDRESS + ",9.9",
            VALID_ADDRESS + ",9",
    })
    void testErrorNotFoundPolicy(String policyAddress, String policyVersion) {
        policyCoreLiteResource.doStart();
        ResponseEntity<Map<String, Serializable>> actualResponse = policyCoreLiteResource.postResponse(policyAddress, policyVersion, VALID_BUSINESS_EVENT_A);
        Map<String, Serializable> expectedResponse = new HashMap<String, Serializable>() {
            {
                put("id", ChassisErrorCode.NOT_FOUND);
                put("text", "Policy not found");
                put("developerText", "Policy not found [request address=%s, request version=%s]".formatted(policyAddress, policyVersion));
            }
        };
        assertEquals(expectedResponse, actualResponse.getBody());
    }
}
