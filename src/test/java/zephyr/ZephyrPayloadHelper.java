package zephyr;

import static helpers.DateHelper.dateFormatter;
import static helpers.TestConstants.CURRENT_DATE_PLACEHOLDER;
import static java.lang.String.format;
import static java.util.Objects.isNull;
import static org.apache.commons.lang3.StringUtils.isNotBlank;
import static zephyr.ZephyrConstants.DATE_HOUR_PATTERN;
import static zephyr.ZephyrConstants.ZEPHYR_ALL_STEPS_PLACE_HOLDER;
import static zephyr.ZephyrConstants.ZEPHYR_TEST_CASE_KEY_PLACE_HOLDER;
import static zephyr.ZephyrConstants.ZEPHYR_TEST_CASE_NAME_PLACE_HOLDER;
import static zephyr.ZephyrConstants.ZEPHYR_TEST_CASE_ZONE_PLACE_HOLDER;
import static zephyr.ZephyrConstants.ZEPHYR_TEST_CYCLE_KEY_PLACE_HOLDER;
import static zephyr.ZephyrConstants.ZEPHYR_TEST_SCRIPT_PLAIN_DESCRIPTION_PLACE_HOLDER;
import static zephyr.ZephyrConstants.ZEPHYR_TEST_STATUS_PLACE_HOLDER;
import static zephyr.ZephyrConstants.ZEPHYR_TEST_STEP_DESCRIPTION_PLACE_HOLDER;

import java.io.FileReader;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.IOUtils;

public class ZephyrPayloadHelper {

	public static ZephyrPayloadHelper instance;

	private ZephyrPayloadHelper() {

	}

	public static ZephyrPayloadHelper getInstance() {

		if (isNull(instance)) {
			instance = new ZephyrPayloadHelper();
		}

		return instance;
	}

	public String getZephyrPayloadAsString(final String fileName, final String testName, final String zone,
		final String testStepDescription, final String testCaseKey, final String testCycleKey, final String status, final String allSteps)
		throws IOException {

		final String payload = getPayloadFromFile(fileName);

		return applyReplacementsToPayload(testName, zone, testStepDescription, testCaseKey, testCycleKey, status,
			allSteps, payload);
	}

	private String applyReplacementsToPayload(final String testName, final String zone, final String testStepDescription,
		final String testCaseKey,
		final String testCycleKey, final String status, final String allSteps, String payload) {

		final Map<String, String> replacements = new HashMap<>();

		replacements.put(ZEPHYR_TEST_CASE_NAME_PLACE_HOLDER, testName);
		replacements.put(ZEPHYR_TEST_CASE_ZONE_PLACE_HOLDER, zone);
		replacements.put(ZEPHYR_TEST_STEP_DESCRIPTION_PLACE_HOLDER, escapeDoubleQuotes(testStepDescription));
		replacements.put(ZEPHYR_TEST_CASE_KEY_PLACE_HOLDER, testCaseKey);
		replacements.put(ZEPHYR_TEST_CYCLE_KEY_PLACE_HOLDER, testCycleKey);
		replacements.put(ZEPHYR_TEST_STATUS_PLACE_HOLDER, status);
		replacements.put(ZEPHYR_ALL_STEPS_PLACE_HOLDER, allSteps);
		replacements.put(ZEPHYR_TEST_SCRIPT_PLAIN_DESCRIPTION_PLACE_HOLDER, escapeDoubleQuotes(testStepDescription));
		replacements.put(CURRENT_DATE_PLACEHOLDER, dateFormatter(new Date(), DATE_HOUR_PATTERN));

		for (final Map.Entry<String, String> entry : replacements.entrySet()) {
			if (isNotBlank(entry.getValue())) {
				payload = payload.replace(entry.getKey(), entry.getValue());
			}
		}

		return payload;
	}

	private String escapeDoubleQuotes(final String input) {

		return isNotBlank(input) ? input.replace("\"", "'") : null;
	}

	private String getPayloadFromFile(final String fileName) throws IOException {

		final String filePath = format(ZephyrConstants.FILE_PATH_FORMAT, fileName);
		final String payload;

		try (final FileReader fileReader = new FileReader(filePath)) {
			payload = IOUtils.toString(fileReader);
		}

		return payload;
	}

}
