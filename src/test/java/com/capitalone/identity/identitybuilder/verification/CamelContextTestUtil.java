package com.capitalone.identity.identitybuilder.verification;

import com.capitalone.identity.identitybuilder.policycore.camel.external.dynamic.DynamicPolicyHelper;
import lombok.SneakyThrows;
import org.apache.camel.CamelContext;
import org.apache.camel.impl.DefaultCamelContext;
import org.apache.camel.model.ModelCamelContext;
import org.apache.camel.model.dataformat.JsonDataFormat;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

import java.io.InputStream;

import static java.util.Collections.singletonMap;

public class CamelContextTestUtil {

  public static CamelContext createDefaultCamelContext() {
    final CamelContext camelContext = new DefaultCamelContext();
    camelContext.adapt(ModelCamelContext.class).setDataFormats(singletonMap("jackson", new JsonDataFormat()));
    return camelContext;
  }

  /**
   * Loads the given process xml into the camel context
   * @param processXmlName the name of the process xml file (located in src/test/resources/camel/ directory).
   * @param camelContext the camel context to load the xml into
   */
  @SneakyThrows
  public static void loadProcessXml(final String processXmlName, final CamelContext camelContext) {
    final Resource resource = new ClassPathResource("camel/%s".formatted(processXmlName));
    try (InputStream is = resource.getInputStream()) {
      DynamicPolicyHelper.loadRouteDefinitionsIntoCamelContext(camelContext, is);
    }
  }
}
