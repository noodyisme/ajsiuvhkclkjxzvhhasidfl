package com.capitalone.identity.identitybuilder.masterbuilder.components.domain;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.util.Map;


public class DomainExceptionTest {

	private static final String DOMAIN_NAME = "domainName";
	private static final String POLICY_NAME = "policyName";
	private static final String POLICY_VERSION = "3.2";
	private static final String METHOD = "post";
	private static final Map<String, Object> ERROR_BODY = Map.of("foo", "bar");
	
	private static final String EXPECTED_TOSTRING = 
        "The %s domain policy \"%s\" version \"%s\" (%s method) returned the following error \"%s\"".formatted(
            DOMAIN_NAME, POLICY_NAME, POLICY_VERSION, METHOD, ERROR_BODY.toString());
	
	@Test
	public void testConstructorAndToString() {
		DomainException e = new DomainException(DOMAIN_NAME, POLICY_NAME, POLICY_VERSION, METHOD, ERROR_BODY);
		Assertions.assertSame(DOMAIN_NAME, e.getDomain());
		Assertions.assertSame(POLICY_NAME, e.getPolicyName());
		Assertions.assertSame(POLICY_VERSION, e.getPolicyVersion());
		Assertions.assertSame(METHOD, e.getMethod());
		Assertions.assertSame(ERROR_BODY, e.getBody());
		Assertions.assertEquals(EXPECTED_TOSTRING , e.toString());
	}
}
