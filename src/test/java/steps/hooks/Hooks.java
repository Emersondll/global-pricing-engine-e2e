package steps.hooks;

import static configs.EnvironmentConstants.EXECUTE_CLEAR_PROCESS;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import context.DataCreatedInTestContext;
import context.TestContext;
import context.TestContextService;
import helpers.ClearDataHelper;
import helpers.DynamicIdsHelper;
import io.cucumber.java.After;
import io.cucumber.java.Before;
import io.cucumber.java.Scenario;

public class Hooks {

	private static final Logger LOGGER = LoggerFactory.getLogger(Hooks.class);

	private TestContextService testContextService() {

		return TestContextService.getInstance();
	}

	@Before
	public void before(final Scenario scenario) {

		LOGGER.info("=== Test begin ===");
		LOGGER.info("Resetting Test Context");
		testContextService().reset();
		final TestContext testContext = testContextService().getTestContext();

		testContext.setUniqueId(generateUniqueId(scenario));
		testContext.setTaxId(generateDynamicTaxId());
		testContext.setDynamicVendorAccountId(generateDynamicVendorAccountId());
		testContext.setDynamicVendorDeliveryCenterId(generateDynamicVendorDeliveryCenterId());
		testContext.setDynamicPriceListId(generateDynamicPriceListId());
	}

	private String generateUniqueId(final Scenario scenario) {

		return scenario.getUri() + scenario.getName() + scenario.getLine();
	}

	@After
	public void after() {

		final TestContext testContext = testContextService().getTestContext();

		final String vendorIdToken = testContext.getLastAuthorization();
		final String dynamicVendorAccountId = testContext.getDynamicVendorAccountId();
		final String dynamicPriceList = testContext.getDynamicPriceListId();
		final String country = testContext.getCountry();
		final DataCreatedInTestContext dataCreatedInTestContext = testContext.getDataCreatedInTestContext();

		try {
			if (EXECUTE_CLEAR_PROCESS) {
				ClearDataHelper.getInstance()
						.clearDataBase(vendorIdToken, dynamicVendorAccountId, dynamicPriceList, country, dataCreatedInTestContext, false);
			}
		} catch (final Throwable e) {
			LOGGER.error("Error while clear database from e2e data.", e);
			throw e;
		} finally {
			LOGGER.info("=== Test end ===");
		}
	}

	private String generateDynamicTaxId() {

		final String dynamicTaxId = DynamicIdsHelper.getInstance().generateDynamicTaxId(StringUtils.EMPTY);
		LOGGER.info("Generating dynamic vendorAccountId: " + dynamicTaxId);
		return dynamicTaxId;
	}

	private String generateDynamicVendorAccountId() {

		final String dynamicVendorAccountId = DynamicIdsHelper.getInstance().generateDynamicVendorAccountId(StringUtils.EMPTY);
		LOGGER.info("Generating dynamic vendorAccountId: " + dynamicVendorAccountId);
		return dynamicVendorAccountId;
	}

	private String generateDynamicVendorDeliveryCenterId() {

		final String dynamicVendorDeliveryCenterId = DynamicIdsHelper.getInstance().generateDynamicDeliveryCenterId(StringUtils.EMPTY);
		LOGGER.info("Generating dynamic vendorDeliveryCenterId: " + dynamicVendorDeliveryCenterId);
		return dynamicVendorDeliveryCenterId;
	}

	private String generateDynamicPriceListId() {

		final String dynamicPriceListId = DynamicIdsHelper.getInstance().generateDynamicPriceListId(StringUtils.EMPTY);
		LOGGER.info("Generating dynamic priceListIid: " + dynamicPriceListId);
		return dynamicPriceListId;
	}
}
