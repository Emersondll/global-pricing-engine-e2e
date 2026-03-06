import static configs.EnvironmentConfig.runAccountServiceLocally;
import static configs.EnvironmentConfig.runChargeServiceLocally;
import static configs.EnvironmentConfig.runComboServiceLocally;
import static configs.EnvironmentConfig.runDealServiceLocally;
import static configs.EnvironmentConfig.runEmptyServiceLocally;
import static configs.EnvironmentConfig.runEnforcementServiceLocally;
import static configs.EnvironmentConfig.runItemServiceLocally;
import static configs.EnvironmentConfig.runPriceServiceLocally;
import static configs.EnvironmentConfig.runPricingEngineLocally;
import static configs.EnvironmentConfig.runPromotionServiceLocally;
import static configs.EnvironmentConstants.ENVIRONMENT_UAT;
import static io.cucumber.junit.platform.engine.Constants.FILTER_TAGS_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.GLUE_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.PARALLEL_CONFIG_FIXED_PARALLELISM_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.PARALLEL_CONFIG_STRATEGY_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.PARALLEL_EXECUTION_ENABLED_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.PLUGIN_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.PLUGIN_PUBLISH_ENABLED_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.PLUGIN_PUBLISH_QUIET_PROPERTY_NAME;
import static io.cucumber.junit.platform.engine.Constants.SNIPPET_TYPE_PROPERTY_NAME;
import static java.util.Objects.isNull;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.json.JSONException;
import org.junit.platform.suite.api.ConfigurationParameter;
import org.junit.platform.suite.api.IncludeEngines;
import org.junit.platform.suite.api.SelectDirectories;
import org.junit.platform.suite.api.Suite;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import context.TestContext;
import context.TestContextService;
import helpers.GenerateAuthorization;
import helpers.GetLastCommitHashFromGit;
import helpers.VendorEnum;
import io.cucumber.java.After;
import io.cucumber.java.AfterAll;
import io.cucumber.java.BeforeAll;
import io.cucumber.java.Scenario;
import net.minidev.json.parser.ParseException;
import zephyr.ZephyrTestCaseHelper;
import zephyr.ZephyrTestCaseKeyNameFileHelper;
import zephyr.ZephyrTestCycleHelper;

@Suite
@IncludeEngines("cucumber")
@SelectDirectories("src/test/resources/features")
@ConfigurationParameter(key = PLUGIN_PUBLISH_ENABLED_PROPERTY_NAME, value = "true")
@ConfigurationParameter(key = SNIPPET_TYPE_PROPERTY_NAME, value = "camelcase")
@ConfigurationParameter(key = GLUE_PROPERTY_NAME, value = "")
@ConfigurationParameter(key = PARALLEL_EXECUTION_ENABLED_PROPERTY_NAME, value = "true")
@ConfigurationParameter(key = PARALLEL_CONFIG_STRATEGY_PROPERTY_NAME, value = "fixed")
@ConfigurationParameter(key = PARALLEL_CONFIG_FIXED_PARALLELISM_PROPERTY_NAME, value = "100")
@ConfigurationParameter(key = PLUGIN_PUBLISH_QUIET_PROPERTY_NAME, value = "true")
@ConfigurationParameter(key = PLUGIN_PROPERTY_NAME, value = "pretty, html:target/site/cucumber-pretty, json:target/cucumber.json, html:target/cucumber")
@ConfigurationParameter(key = FILTER_TAGS_PROPERTY_NAME, value = "@ok")//"@ok or @warning or @check"
public class CucumberAutomatedTest {

	private static final String UPDATE_ZEPHYR_ARG = "updateZephyr";
	private static final Logger LOGGER = LoggerFactory.getLogger(CucumberAutomatedTest.class);
	private static String testCycleKey;

	private static ZephyrTestCycleHelper zephyrTestCycleHelper;
	private static ZephyrTestCaseHelper zephyrTestCaseHelper;

	private static ZephyrTestCaseKeyNameFileHelper zephyrTestCaseKeyNameFileHelper;

	private static TestContextService testContext() {

		return TestContextService.getInstance();
	}

	@BeforeAll
	public static void setUp() throws IOException {

		LOGGER.info("=== Starting Automated Tests ===");

		LOGGER.info("price-service LOCAL: " + runPriceServiceLocally());
		LOGGER.info("charge-service LOCAL: " + runChargeServiceLocally());
		LOGGER.info("deal-service LOCAL: " + runDealServiceLocally());
		LOGGER.info("combo-service LOCAL: " + runComboServiceLocally());
		LOGGER.info("account-service LOCAL: " + runAccountServiceLocally());
		LOGGER.info("item-service LOCAL: " + runItemServiceLocally());
		LOGGER.info("pricing-engine LOCAL: " + runPricingEngineLocally());
		LOGGER.info("enforcement-service LOCAL: " + runEnforcementServiceLocally());
		LOGGER.info("empties-service LOCAL: " + runEmptyServiceLocally());
		LOGGER.info("promotion-service LOCAL: " + runPromotionServiceLocally());

		fillTheGlobalIdPrefixInGlobalContext();
		fillAuthorizationsIntoGlobalContext();

		if (shouldUpdateZephyr()) {
			zephyrTestCaseKeyNameFileHelper = ZephyrTestCaseKeyNameFileHelper.getInstance();
			zephyrTestCycleHelper = ZephyrTestCycleHelper.getInstance();
			zephyrTestCaseHelper = ZephyrTestCaseHelper.getInstance();

			LOGGER.info("created zephyr test cycle");
			zephyrTestCaseKeyNameFileHelper.readFromTestCaseNamesFile();
			testCycleKey = zephyrTestCycleHelper.createTestCycle();

		}

	}

	private static void fillTheGlobalIdPrefixInGlobalContext() {

		final TestContext testContext = testContext().getGlobalTestContext();

		final String gitHash = GetLastCommitHashFromGit.getInstance().execute();
		final LocalDate date = LocalDate.now();

		// The global id prefix is a combination of the git hash with the current date.
		final String globalIdPrefix = gitHash + "_" + date;

		LOGGER.info("Global Id Prefix: " + globalIdPrefix);

		testContext.setGlobalIdPrefix(globalIdPrefix);
		// testContext.setGlobalIdPrefix(String.valueOf(System.currentTimeMillis()));
	}

	private static void fillAuthorizationsIntoGlobalContext() {

		final TestContext testContext = testContext().getGlobalTestContext();

		final List<String> vendorIds = Arrays.stream(VendorEnum.values())
			.filter(vendor -> ENVIRONMENT_UAT.equalsIgnoreCase(vendor.getEnvironment()))
			.map(VendorEnum::getVendorId)
			.collect(Collectors.toList());

		vendorIds.parallelStream().forEach(vendorId ->
			testContext.addAuthorizationByVendorId(vendorId, GenerateAuthorization.getInstance().execute(ENVIRONMENT_UAT, vendorId)));
	}

	@After
	public static void updateZephyr(final Scenario scenario) throws IOException, JSONException, ParseException {

		if (!shouldUpdateZephyr()) {
			LOGGER.info("Zephyr not set to update");
			return;
		}

		LOGGER.info("Updating Zephyr true");

		if (isNull(zephyrTestCaseHelper.getTestCaseKeyByTestCaseName(scenario.getName()))) {
			final TestContext testContext = testContextService().getTestContext();
			zephyrTestCaseHelper.createTestCaseInZephyr(scenario, testContext.getCountry());
		}

		zephyrTestCycleHelper.createTestCycleExecutionToTestCase(scenario, testCycleKey);
	}

	@AfterAll
	public static void tearDown() throws IOException {

		if (shouldUpdateZephyr()) {
			zephyrTestCaseKeyNameFileHelper.writeToMapTestCaseNamesFile();
		}

		LOGGER.info("=== Automated Tests Finished ===");

		LOGGER.info("Global Id Prefix: " + testContext().getGlobalTestContext().getGlobalIdPrefix());
	}

	private static TestContextService testContextService() {

		return TestContextService.getInstance();
	}

	private static boolean shouldUpdateZephyr() {

		final String updateZephyr = System.getProperty(UPDATE_ZEPHYR_ARG);
		return Boolean.parseBoolean(updateZephyr);
	}

}
