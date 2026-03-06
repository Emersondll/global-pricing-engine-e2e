package helpers;

import static helpers.JsonLoader.getRequestDataFileContent;
import static helpers.TestConstants.AUTHORIZATION_HEADER;
import static io.restassured.RestAssured.given;
import static org.apache.commons.lang3.ObjectUtils.isNotEmpty;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import context.TestContext;
import context.TestContextService;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;

public class BaseStepDefinitions {

	protected TestContext getTestContext() {

		return TestContextService.getInstance().getTestContext();
	}

	protected TestContext getGlobalTestContext() {

		return TestContextService.getInstance().getGlobalTestContext();
	}

	protected Response doRequest(final TestContext testContext) throws IOException {

		final String authorization = testContext.getAuthorization();
		final String payloadFileName = testContext.getPayloadFileName();
		final Map<String, Object> headers = testContext.getRequestHeaders();
		final Map<String, Object> params = testContext.getRequestParams();

		final RequestSpecification request = given();
		if (isNotEmpty(payloadFileName)) {
			request.body(getRequestDataFileContent(testContext, payloadFileName));
		}
		if (isNotEmpty(headers)) {
			request.headers(headers);
		}
		if (isNotEmpty(params)) {
			request.queryParams(params);
		}
		if (isNotEmpty(authorization)) {
			request.header(AUTHORIZATION_HEADER, authorization);
		}
		return request.when().request(testContext.getRequestMethod(), testContext.getRequestEndpoint());
	}

	protected void clearRequestData(final TestContext testContext) {

		testContext.setAuthorization(null);
		testContext.setPayloadFileName(null);
		testContext.setRequestHeaders(new LinkedHashMap<>());
		testContext.setRequestParams(new LinkedHashMap<>());
		testContext.setRequestMethod(null);
		testContext.setRequestEndpoint(null);
		testContext.setCustomSecondsToAwait(null);
	}
}
