package com.capitalone.identity.identitybuilder.masterbuilder.policycorelite;

import com.amazonaws.regions.Regions;
import com.capitalone.identity.identitybuilder.client.ConfigStoreClient;
import com.capitalone.identity.identitybuilder.client.ConfigStoreClient_ApplicationEventPublisher;
import com.capitalone.identity.identitybuilder.client.dynamic.PollingConfiguration;
import com.capitalone.identity.identitybuilder.client.s3.ConfigStoreClientS3Configuration;
import com.capitalone.identity.identitybuilder.configmanagement.MatchingStrategies;
import com.capitalone.identity.platform.implementation.configuration.ConfigPolicyRuntimeContext;
import com.capitalone.identity.platform.sdk.loading.AggregateEntityLoadListener;
import com.capitalone.identity.platform.sdk.loading.PolicyLoadManager;
import com.capitalone.identity.platform.sdk.versioning.PolicyVersionEventListener;
import com.capitalone.identity.platform.sdk.versioning.PolicyVersionService;
import lombok.Getter;
import org.apache.logging.log4j.util.Strings;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import java.time.Duration;

@ConditionalOnProperty(PolicyCoreLiteConfigStore.POLICY_CORE_LITE_RESOURCE_ENABLED)
@Getter
@Component
public class PolicyCoreLiteConfigStore {
    public static final String POLICY_CORE_LITE_RESOURCE_ENABLED = "identitybuilder.testbedservices.policycoreliteresource.enabled";
    private final ConfigStoreClient client;
    private final PolicyVersionService versionService;
    private final ConfigPolicyRuntimeContext runtimeContext;
    private final PolicyLoadManager loadManager;
    private final AggregateEntityLoadListener publisher;



    public PolicyCoreLiteConfigStore(@Value("${csc.s3.bucket-name.east-region:#{null}}") String bucket,
                                     @Value("${csc.s3.override-region:#{null}}") String overrideRegion,
                                     @Value("${csc.aws.proxy.enabled:false}") boolean isProxyEnabled,
                                     @Value("${csc.dev-local.aws-credential-profile-name:#{null}}") String devLocalAwsCredentialProfileName) {
        this.client = ConfigStoreClient.newS3Client(new ConfigStoreClientS3Configuration(
                        bucket,
                        "us_consumers/ep2_identity_builder_test/idbcore_demo_configonly",
                        Strings.isBlank(overrideRegion) ? Regions.US_EAST_1 : Regions.fromName(overrideRegion),
                        devLocalAwsCredentialProfileName,
                        isProxyEnabled
                ),
                new PollingConfiguration(Duration.ofMinutes(5)),
                ConfigStoreClient_ApplicationEventPublisher.EMPTY
        );

        this.versionService = new PolicyVersionService();
        this.runtimeContext = new ConfigPolicyRuntimeContext(MatchingStrategies.MATCH_ALL_NON_NULL);
        this.publisher = new AggregateEntityLoadListener(new PolicyVersionEventListener(versionService));
        this.loadManager = new PolicyLoadManager(runtimeContext, publisher, client, false);
        loadManager.initialize();
    }
}
