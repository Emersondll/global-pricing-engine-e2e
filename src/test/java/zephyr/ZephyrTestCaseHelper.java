package zephyr;

import static java.lang.String.format;
import static java.lang.String.join;

import java.io.IOException;
import java.text.MessageFormat;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.CopyOnWriteArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import io.cucumber.java.Scenario;
import io.restassured.http.Method;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;

public class ZephyrTestCaseHelper {

	private static final Logger LOGGER = LoggerFactory.getLogger(ZephyrTestCaseHelper.class);
	private static ZephyrTestCaseHelper instance;
	private static ZephyrStepsHelper zephyrStepsHelper;
	private static ZephyrPayloadHelper zephyrPayloadHelper;
	private static ZephyrRequestHelper zephyrRequestHelper;

	private static ZephyrTestCaseKeyNameFileHelper zephyrTestCaseKeyNameFileHelper;

	private ZephyrTestCaseHelper() {

		zephyrStepsHelper = ZephyrStepsHelper.getInstance();
		zephyrPayloadHelper = ZephyrPayloadHelper.getInstance();
		zephyrRequestHelper = ZephyrRequestHelper.getInstance();
		zephyrTestCaseKeyNameFileHelper = ZephyrTestCaseKeyNameFileHelper.getInstance();
	}

	public static ZephyrTestCaseHelper getInstance() {

		if (Objects.isNull(instance)) {
			instance = new ZephyrTestCaseHelper();
		}

		return instance;
	}

	public void createTestCaseInZephyr(final Scenario scenario, final String zone) throws IOException {

		final String payload = zephyrPayloadHelper.getZephyrPayloadAsString(ZephyrConstants.BASIC_TEST_CASE_FILE_NAME, scenario.getName(),
			zone, null, null,
			null,
			null, null);

		final Response response = zephyrRequestHelper.doRequest(Method.POST, payload, ZephyrConstants.TESTCASES_ENDPOINT);

		final JsonPath bodyResponse = response.jsonPath();

		putTestCaseKeyByTestCaseName(scenario.getName(), bodyResponse.get("key"));

		try {
			final List<String> scenarioSteps = zephyrStepsHelper.getStepsFrom(scenario);
			LOGGER.info(MessageFormat.format("Scenario steps for scenario \n {0}:\n\n {1}", scenario.getName(), scenarioSteps));
			createTestScriptPlain(bodyResponse.get("key"), scenarioSteps);
		} catch (final NoSuchFieldException | IllegalAccessException noSuchFieldException) {
			LOGGER.error("Scenario steps not found.");
		}
	}

	public String getTestCaseKeyByTestCaseName(final String scenarioName) {

		String scenarioKey = null;

		final CopyOnWriteArrayList<ZephyrTestCase> testCases = new CopyOnWriteArrayList<>(
			zephyrTestCaseKeyNameFileHelper.getZephyrTestCaseKeyNameList());

		for (final ZephyrTestCase zephyrTestCase : testCases) {
			if (Objects.equals(zephyrTestCase.getScenarioName(), scenarioName)) {
				scenarioKey = zephyrTestCase.getScenarioKey();
				break;
			}
		}

		return scenarioKey;
	}

	public void putTestCaseKeyByTestCaseName(final String name, final String testCaseKey) {

		final ZephyrTestCase zephyrTestCase = new ZephyrTestCase(name, testCaseKey);
		zephyrTestCaseKeyNameFileHelper.addToZephyrTestCaseKeyNameList(zephyrTestCase);

	}

	public void createTestScriptPlain(final String scenarioKey, final List<String> steps) throws IOException {

		final String stepsAsString = join(ZephyrConstants.LINE_BREAKER, steps);

		final String payload = zephyrPayloadHelper.getZephyrPayloadAsString(ZephyrConstants.BASIC_TEST_SCRIPT_PLAIN_FILE_NAME, null, null,
			stepsAsString,
			null, null, null, null);

		final String endpoint = format(ZephyrConstants.TESTSCRIPT_ENDPOINT_FORMAT, scenarioKey);
		zephyrRequestHelper.doRequest(Method.POST, payload, endpoint);

	}

}
