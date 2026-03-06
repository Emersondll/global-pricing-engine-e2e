package zephyr;

public class ZephyrConstants {

	public static final String ZEPHYR_AUTHORIZATION = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb250ZXh0Ijp7ImJhc2VVcmwiOiJodHRwczovL2FiLWluYmV2LmF0bGFzc2lhbi5uZXQiLCJ1c2VyIjp7ImFjY291bnRJZCI6IjU1NzA1ODowZDk5NDFhZi0xYzEzLTQ0N2UtYmZiZi05N2EyODU0ODRlYmMifX0sImlzcyI6ImNvbS5rYW5vYWgudGVzdC1tYW5hZ2VyIiwic3ViIjoiamlyYTo2ZWVhNjU2OS1iOWZiLTRiMmUtYThkZS02ZTZkMTdiNGZmZWUiLCJleHAiOjE3MDM4NTg5NTIsImlhdCI6MTY3MjMyMjk1Mn0.rD3_dSr-vrzHyLn9iQ_ThYf5cytN5xoMe3AfYTDDh_I";

	public static final String ZEPHYR_TEST_CASE_NAME_PLACE_HOLDER = "## WILL BE REPLACE BY TEST CASE NAME ##";
	public static final String ZEPHYR_TEST_CASE_ZONE_PLACE_HOLDER = "## WILL BE REPLACE BY TEST CASE ZONE ##";
	public static final String ZEPHYR_TEST_STEP_DESCRIPTION_PLACE_HOLDER = "## WILL BE REPLACE BY TEST STEP DESCRIPTION ##";
	public static final String ZEPHYR_TEST_CASE_KEY_PLACE_HOLDER = "## WILL BE REPLACE BY ZEPHYR TEST CASE KEY ##";
	public static final String ZEPHYR_TEST_CYCLE_KEY_PLACE_HOLDER = "## WILL BE REPLACE BY ZEPHYR TEST CYCLE KEY ##";
	public static final String ZEPHYR_TEST_STATUS_PLACE_HOLDER = "## WILL BE REPLACE BY ZEPHYR TEST STATUS ##";
	public static final String ZEPHYR_ALL_STEPS_PLACE_HOLDER = "\"## WILL BE REPLACE BY ALL TEST STEPS ##\"";
	public static final String ZEPHYR_TEST_SCRIPT_PLAIN_DESCRIPTION_PLACE_HOLDER = "## WILL BE REPLACE BY TEST SCRIPT PLAIN DESCRIPTION ##";
	public static final String DATE_HOUR_PATTERN = "yyyy-MM-dd'T'HH:mm:ss'Z'";
	public static final String LINE_BREAKER = "\\r\\n";
	public static final String BASIC_TEST_SCRIPT_PLAIN_FILE_NAME = "basic-test-script-plain";
	public static final String TEST_EXECUTIONS_ENDPOINT = "/testexecutions";
	public static final String FILE_PATH_FORMAT = "src/test/resources/payloads/zephyr/%s.json";
	public static final String AUTHORIZATION_HEADER = "Authorization";
	public static final String CONTENT_TYPE_HEADER = "Content-Type";
	public static final String APPLICATION_JSON = "application/json";
	public static final String ZEPHYR_BASE_URL_FORMAT = "https://api.zephyrscale.smartbear.com/v2%s";
	public static final String TESTCASES_ENDPOINT = "/testcases";
	public static final String BASIC_TEST_CASE_FILE_NAME = "basic-test-case";
	public static final String TESTSCRIPT_ENDPOINT_FORMAT = "/testcases/%s/testscript";
	public static final String TEST_CASE_KEY_NAME_FILE_PATH = "src/test/resources/payloads/zephyr/map-test-case-key-to-test-case-name.json";
	public static final String TEST_CYCLES_ENDPOINT = "/testcycles";
	public static final String BASIC_TEST_CYCLE_FILE_NAME = "basic-test-cycle";
	public static final String BASIC_TEST_EXECUTION_FILE_NAME = "basic-test-execution";

	private ZephyrConstants() {

	}
}
