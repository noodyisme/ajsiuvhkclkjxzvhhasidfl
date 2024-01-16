function fn() {
	var env = karate.properties['karate.env'];
	var hostName = karate.properties['karate.hostName'];
	var testhost = karate.properties['test-host']
	karate.log('karate.env system property was:', env);
	karate.log('testhost system property was:', testhost);
	karate.configure('retry',{ count:5, interval:4000});

	var config = {
		env: env,
		URL: '',
		access: '',
		result: '',
		enableSSL: true,
		req_headers: {
			'Api-Key': 'MOBILE',
			'Accept': 'application/json;v=2',
			'Customer-IP-Address': '127.0.0.1',
			'Accept-Language': 'en-US',
			'Client-Correlation-Id': 'platformersRegression',
			'Channel-Type': 'web',
			'Country-Code': 'US',
			'client_id': '2c09762ca0304452bd36054f903243c0'
		}
	}

	var host = '';
	if (env == 'local'){
		host = 'localhost:9082';
		env = 'local';
	}else if (env == 'dev') {
		host = 'idb-core-dev.stdt-qa.aws.cb4good.com'
	} else if (env == 'qa-b-e1') {
		host = 'masterbuilder-2-0-qa-b-e1.baidentitypolicyservices.stdt-qa.aws.cb4good.com';
		env = 'qa-inactiveStack';
	} else if (env == 'qa-b-w2') {
		host = 'masterbuilder-2-0-qa-b-w2.baidentitypolicyservices.stdt-qa.aws.cb4good.com';
		env = 'qa-inactiveStack';
	} else if (env == 'qa-g-e1') {
		host = 'masterbuilder-2-0-qa-g-e1.baidentitypolicyservices.stdt-qa.aws.cb4good.com';
		env = 'qa-inactiveStack';
	} else if (env == 'qa-g-w2') {
		host = 'masterbuilder-2-0-qa-g-w2.baidentitypolicyservices.stdt-qa.aws.cb4good.com';
		env = 'qa-inactiveStack';
	} else if (env == 'perf') {
		host = 'idb-core-perf.clouddqt.capitalone.com';
		//masterbuilder-2-0-perf-w2.baidentitypolicyservices.stdt-qa.aws.cb4good.com
		env = 'qa-inactiveStack';
	} else if (env == null) {
		//defaulting to local if no environment given.
		host = 'localhost:9082';
		env = 'local';
	}

	if (testhost) {
		config.URL = testhost;
	} else {
		if (env == 'custom') {
			karate.log('karate.hostName system property was:', hostName);
			config.URL = 'https://' + hostName + '/masterbuilder-2-0-web/identity/workflow-management/initiate-policy';
		}
		else if (env == 'dev') {
			config.URL = 'https://' + host + '/masterbuilder-2-0-web/identity/workflow-management/initiate-policy';
		}
		else if (env == 'qa') {
			host = 'api-it.cloud.capitalone.com'
			config.URL = 'https://' + host + '/identity/workflow-management/initiate-policy';
		}
		else if (env == 'qa-inactiveStack') {
			config.URL = 'https://' + host + '/masterbuilder-2-0-web/identity/workflow-management/initiate-policy';
		}
		else if (env == 'qa-inactiveStack' || env == 'local') {
			config.URL = 'https://' + host + '/masterbuilder-2-0-web/identity/workflow-management/initiate-policy';
		}
		else {
			throw ('Unknown environment: ' + env );
		}
	}
	config.FILE_UPLOAD_URL = 'https://' + host + '/domain-web/private/189898/identity/domain/services/upload'
	return config;
}