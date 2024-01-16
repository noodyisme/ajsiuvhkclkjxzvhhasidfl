# idb-core-testbed-services · [![Build Status](https://digitechjenkins.cloud.capitalone.com/buildStatus/icon?job=Bogie/identitybuilder/idb-core-testbed-services/master)](https://digitechjenkins.cloud.capitalone.com/job/Bogie/job/identitybuilder/job/idb-core-testbed-services/job/master/) [![Coverage](https://sonar.cloud.capitalone.com/api/project_badges/measure?project=com.capitalone.identity.identitybuilder%3Amasterbuilder-2-idbcore&metric=coverage)](https://sonar.cloud.capitalone.com/dashboard?id=com.capitalone.identity.identitybuilder%3Amasterbuilder-2-idbcore)
idb-core-testbed-services using [identity-builder-policy-core](https://github.cloud.capitalone.com/identitybuilder/identity-builder-policy-core) artifact

---
## API specification
[**Identity Platform Master Builder v2.0**](https://exchange.cloud.capitalone.com/apis/11849/2.0/docs)

---

## Running locally
**Prerequisite**: Member of LDAP group with read access to the masterbuilder lockbox.
### Retrieve certs from lockbox (one time)
Start [Docker](https://www.docker.com/products/docker-desktop) and run the following [vault-buddy](https://github.cloud.capitalone.com/cpk642/vault-buddy) command from this repos's root directory:
```shell
export VAULT_ADDR=https://chamber-qa.clouddqt.capitalone.com
export VAULT_TOKEN=$(vault login -token-only -method=ldap -path=aws-ldap username=${USER})
docker run -v ~/certs:/app/certs \
    -v $(pwd):/app/src \
    --network=host \
    -e VAULT_AUTH_ROLE=${USER} \
    -e VAULT_TOKEN=${VAULT_TOKEN} \
    -e SECRETS_CONFIG=/app/src/secrets-nonprod.yaml \
    artifactory.cloud.capitalone.com/cpk642/vault-buddy
```
This will generate a `~/certs` directory containing certificates specified in `secrets-nonprod.yaml`.

### Redis setup (optional)
If you're testing a multi-step policy, install and start a Redis server.
```shell
brew install redis
# starts a Redis server on port 6379
redis-server

# to view cache contents in new terminal window 
redis-cli  
```

### Add PIPs / policies to `csc.dev-local.debug-root-directory`
```shell
cd src/main/resources/external
git clone https://github.cloud.capitalone.com/identitybuilder-policies/routes # PIPs
git clone https://github.cloud.capitalone.com/identitybuilder-policies/card_fraud_policies # example policy repo
```

### Start application
```shell
mvn spring-boot:run -P generate-secrets
```

### Policy development
Please refer this link: [**Identity Builder Documentation**](https://identitybuilder.cloud.capitalone.com/documentation/policies/overview)

---

## CNAME records
| ENV	 | Name            | Value                                 | TTL |
|------|-----------------|---------------------------------------|-----|
| DEV  | Not established | idb-core-dev.stdt-qa.aws.cb4good.com  | 300 |
| QA   | Not Established | Not Established                       | 300 |
| PERF | Not Established | idb-core-perf.stdt-qa.aws.cb4good.com | 300 |

## Monitoring (in QA)
* [**Splunk**](https://splunkoneqa.clouddqt.capitalone.com/en-US/app/DIGITAL_WORKFLOWSERVICES/search?q=search%20index%20%3D%20asvidentitypolicyservices_qa&display.page.search.mode=smart&dispatch.sample_ratio=1&earliest=-15m&latest=now&display.page.search.tab=events&sid=1605493158.866378_BCAE615E-ECDE-4CAC-906B-C50AEF8E84D3)
* [**Datadog**](https://capone-nonprod.datadoghq.com/apm/traces?end=1616177545905&paused=false&query=service%3Amasterbuilder-2-0-dev%20env%3Adev%20operation_name%3Aservlet.request&start=1616176645905&streamTraces=true&storage=hot)
* [**New Relic**](https://one.newrelic.com/launcher/nr1-core.explorer?pane=eyJuZXJkbGV0SWQiOiJhcG0tbmVyZGxldHMub3ZlcnZpZXciLCJpc092ZXJ2aWV3Ijp0cnVlLCJyZWZlcnJlcnMiOnsibGF1bmNoZXJJZCI6Im5yMS1jb3JlLmV4cGxvcmVyIiwibmVyZGxldElkIjoibnIxLWNvcmUubGlzdGluZyJ9LCJlbnRpdHlJZCI6Ik1Ua3lOemN4Tlh4QlVFMThRVkJRVEVsRFFWUkpUMDU4TVRRek56QTROVFl4TUEifQ==&sidebars[0]=eyJuZXJkbGV0SWQiOiJucjEtY29yZS5hY3Rpb25zIiwiZW50aXR5SWQiOiJNVGt5TnpjeE5YeEJVRTE4UVZCUVRFbERRVlJKVDA1OE1UUXpOekE0TlRZeE1BIiwic2VsZWN0ZWROZXJkbGV0Ijp7Im5lcmRsZXRJZCI6ImFwbS1uZXJkbGV0cy5vdmVydmlldyIsImlzT3ZlcnZpZXciOnRydWV9fQ==&platform[filters]=Iihkb21haW4gPSAnQVBNJyBBTkQgdHlwZSA9ICdBUFBMSUNBVElPTicpIEFORCAobmFtZSBMSUtFICdtYXN0ZXJidWlsZGVyLScgT1IgaWQgPSAnbWFzdGVyYnVpbGRlci0nIE9SIGRvbWFpbklkID0gJ21hc3RlcmJ1aWxkZXItJyki&platform[timeRange][duration]=1800000&platform[$isFallbackTimeRange]=true)

---

## Karate testing
### Test in dev
`mvn clean test -Dtest=Karate -Dkarate.env=dev`  

### Run Regression Tests Locally
1. Ensure environment is configured properly:
   * The `MasterBuilderApplication` is running and accepting traffic in your local environment.
   * The Redis cache is initialized and accepting connections.
     * This can be done by typing `redis-server` in any terminal window. Do not modify said terminal window after initializing the cache.
   * The `csc.dev-local.debug-root-directory` flag pointing to a valid directory, or is commented out and your aws token is up-to-date.
2. 
2. Run the test(s).
   1. If you are in the feature file, on the left-hand IDE border, click on the play button next to a feature or the double play button next to an individual test to run your desired test(s).
   2. Alternatively, tests can be run on a given classpath via the command line like so:

      `mvn clean test -Dtest=Karate -Dkarate.env=local -Dkarate.options="classpath:features/policy_core_regression_policies"`

### Test locally
`mvn clean test -Dtest=Karate -Dkarate.env=custom -Dkarate.hostName=127.0.0.1:9082`
> Configure `karate.env` endpoints in `karate-config.js`

### Test specific scenario
Add `-Dkarate.options="--tags @wal_MNO_Payfone_tag`
# ajsiuvhkclkjxzvhhasidfl
# ajsiuvhkclkjxzvhhasidfl
