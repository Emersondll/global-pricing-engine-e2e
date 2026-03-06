package helpers;

import context.TestContext;
import context.TestContextService;

public class DynamicIdsHelper {

	private static final DynamicIdsHelper INSTANCE = new DynamicIdsHelper();

	private DynamicIdsHelper() {

	}

	public static DynamicIdsHelper getInstance() {

		return INSTANCE;
	}

	private TestContextService testContextService() {

		return TestContextService.getInstance();
	}

	public String generateDynamicTaxId(final String suffix) {

		final String dynamicId = generateDynamicId(suffix);
		final long codedLong = EncodeStringAsLongValue.getInstance().execute(dynamicId);

		return CnpjGeneratorHelper.generateCnpj(codedLong, 0);
	}

	public String generateDynamicVendorAccountId(final String suffix) {

		return "e2e-pricing-va-" + generateDynamicValue(suffix);
	}

	public String generateDynamicPriceListId(final String suffix) {

		return "e2e-pricing-pl-" + generateDynamicValue(suffix);
	}

	public String generateDynamicDeliveryCenterId(final String suffix) {

		return "e2e-pricing-dc-" + generateDynamicValue(suffix);
	}

	private String generateDynamicValue(final String suffix) {

		final String dynamicId = generateDynamicId(suffix);
		final long codedLong = EncodeStringAsLongValue.getInstance().execute(dynamicId);
		return EncodeLongAsBase64StringValue.getInstance().execute(codedLong);
	}

	private String generateDynamicId(final String suffix) {

		final TestContext testContext = testContextService().getTestContext();

		final String globalIdPrefix = testContext.getGlobalIdPrefix();
		final String uniqueId = testContext.getUniqueId();

		return globalIdPrefix + "_" + uniqueId + "_" + suffix;
	}
}
