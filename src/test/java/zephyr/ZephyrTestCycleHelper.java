package zephyr;

import static java.util.Objects.isNull;

import java.io.IOException;

import io.cucumber.java.Scenario;
import io.restassured.http.Method;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;

public class ZephyrTestCycleHelper {

	private static ZephyrTestCycleHelper instance;

	private static ZephyrPayloadHelper zephyrPayloadHelper;

	private static ZephyrRequestHelper zephyrRequestHelper;

	private static ZephyrTestCaseHelper zephyrTestCaseHelper;

	private ZephyrTestCycleHelper() {

		zephyrPayloadHelper = ZephyrPayloadHelper.getInstance();
		zephyrRequestHelper = ZephyrRequestHelper.getInstance();
		zephyrTestCaseHelper = ZephyrTestCaseHelper.getInstance();
	}

	public static ZephyrTestCycleHelper getInstance() {

		if (isNull(instance)) {
			instance = new ZephyrTestCycleHelper();
		}

		return instance;
	}

	public String createTestCycle() throws IOException {

		final String payload = zephyrPayloadHelper.getZephyrPayloadAsString(ZephyrConstants.BASIC_TEST_CYCLE_FILE_NAME, null, null, null,
			null, null, null,
			null);

		final Response response = zephyrRequestHelper.doRequest(Method.POST, payload, ZephyrConstants.TEST_CYCLES_ENDPOINT);

		final JsonPath bodyResponse = response.jsonPath();

		return bodyResponse.get("key");
	}

	public void createTestCycleExecutionToTestCase(final Scenario scenario, final String testCycleKey) throws IOException {

		final String status = getStatusForScenario(scenario);
		final String testCaseKey = zephyrTestCaseHelper.getTestCaseKeyByTestCaseName(scenario.getName());
		final String payload = zephyrPayloadHelper.getZephyrPayloadAsString(ZephyrConstants.BASIC_TEST_EXECUTION_FILE_NAME, null, null,
			null, testCaseKey,
			testCycleKey, status, null);

		zephyrRequestHelper.doRequest(Method.POST, payload, ZephyrConstants.TEST_EXECUTIONS_ENDPOINT);
	}

	private String getStatusForScenario(final Scenario scenario) {

		switch (scenario.getStatus()) {
			case PASSED:
				return "Pass";
			case FAILED:
				return "Fail";
			default:
				return "Not Executed";
		}
	}

}
