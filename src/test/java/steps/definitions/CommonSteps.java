package steps.definitions;

import static com.abinbev.b2b.commons.platformId.core.enuns.PlatformIdEnum.COMBO;
import static configs.EnvironmentConstants.ENVIRONMENT_UAT;
import static configs.EnvironmentConstants.POLL_INTERVAL_IN_SECONDS;
import static configs.EnvironmentConstants.SECONDS_TO_AWAIT;
import static helpers.DateHelper.dateFormatter;
import static helpers.JsonLoader.getResponseDataFileContentAsString;
import static helpers.PayloadHelper.writeJsonToFile;
import static helpers.PlatformIdEncoderDecoderHelper.encodeContractId;
import static helpers.PlatformIdEncoderDecoderHelper.encodeDeliveryCenterId;
import static helpers.TestConstants.COUNTRY_HEADER;
import static helpers.TestConstants.DELIVERY_DATE_HEADER;
import static helpers.TestConstants.REQUEST_TRACE_ID_HEADER;
import static helpers.TestConstants.TIMESTAMP_HEADER;
import static helpers.TestConstants.VALID_FROM_DATE_FORMAT;
import static helpers.TestConstants.VENDOR_ID_HEADER;
import static helpers.TimeZoneHelper.getTimeZoneByCountry;
import static java.util.Objects.isNull;
import static java.util.Optional.ofNullable;
import static java.util.concurrent.TimeUnit.SECONDS;
import static org.apache.commons.lang3.StringUtils.EMPTY;
import static org.awaitility.Awaitility.await;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.core.Is.is;
import static org.hamcrest.text.IsEmptyString.emptyString;

import java.time.Duration;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.skyscreamer.jsonassert.JSONAssert;
import org.skyscreamer.jsonassert.JSONCompareMode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.abinbev.b2b.commons.platformId.core.PlatformIdEncoderDecoder;
import com.abinbev.b2b.commons.platformId.core.vo.ComboPlatformId;

import context.TestContext;
import helpers.BaseStepDefinitions;
import helpers.DynamicIdsHelper;
import helpers.GenerateAuthorization;
import helpers.JsonLoader;
import helpers.PayloadHelper;
import helpers.PlatformIdEncoderDecoderHelper;
import io.cucumber.java.After;
import io.cucumber.java.Scenario;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.restassured.filter.log.LogDetail;
import io.restassured.response.Response;

public class CommonSteps extends BaseStepDefinitions {

	private static final String REMOVE_TIME_ZONE_REGEX = "(T[0-9]{2}:[0-9]{2}:[0-9]{2}(.[0-9]*[0-9])*Z)";
	private static final String REMOVE_ACCOUNT_ID_DB_ID_REGEX = "\"\\b(accountId\":)\\s\"*([a-f\\d\\\\-]*)\\s*\",";
	private static final String SEPARATOR = ",";
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonSteps.class);
	private static final PlatformIdEncoderDecoder platformIdEncoderDecoder = new PlatformIdEncoderDecoder();

	@Given("^I have the payload at file \"([^\"]*)\" at folder \"([^\"]*)\"$")
	public void iHaveThePayloadAtFile(final String payloadFileName, final String folder) {

		getTestContext().setPayloadFileName(payloadFileName);
		getTestContext().setFolder(folder);
	}

	@Given("^I have the \"([^\"]*)\" header with list values$")
	public void iHaveTheHeaderWithListValues1(final String param, final List<String> values) {

		final List<String> newValues = values.stream()
				.map(value -> JsonLoader.applyPlaceHolders(value, getTestContext()))
				.collect(Collectors.toList());

		getTestContext().getRequestHeaders().put(param, newValues);
	}

	@Given("^I have the \"([^\"]*)\" header with list values \"([^\"]*)\"$")
	public void iHaveTheHeaderWithListValues2(final String param, final String values) {

		if (values.length() != 0) {
			String newValues = values.substring(0, values.length() - SEPARATOR.length());
			newValues = JsonLoader.applyPlaceHolders(newValues, getTestContext());
			getTestContext().getRequestHeaders().put(param, newValues);
		}
	}

	@Given("^I have the \"([^\"]*)\" header with value \"([^\"]*)\"$")
	public void iHaveTheHeaderWithValue(final String header, final String value) {

		final String newValue = JsonLoader.applyPlaceHolders(value, getTestContext());
		getTestContext().getRequestHeaders().put(header, newValue);

		if ("country".equalsIgnoreCase(header)) {
			getTestContext().setCountry(newValue);
		}
	}

	@Given("^I set the timezone to the \"([^\"]*)\"$")
	public void iSetTheTimezoneHeader(final String country) {

		getTestContext().setTimeZone(getTimeZoneByCountry(country));
	}

	@Given("^I put the timezone header$")
	public void iGetTheTimeZoneHeader() {

		getTestContext().getRequestHeaders().put("timezone", getTestContext().getTimeZone());
	}

	@Given("^I have the \"([^\"]*)\" header with value dynamic account id")
	public void iHaveTheHeaderWithValueDynamicAccountId(final String header) {

		getTestContext().getRequestHeaders().put(header, getTestContext().getDynamicVendorAccountId());
	}

	@Given("^I have the \"([^\"]*)\" header with value dynamic price list id")
	public void iHaveTheHeaderWithValueDynamicPriceListId(final String header) {

		getTestContext().getRequestHeaders().put(header, getTestContext().getDynamicPriceListId());
	}

	@Given("^I have the \"([^\"]*)\" header with value dynamic contract id for key \"([^\"]*)\"$")
	public void iHaveTheHeaderWithValueDynamicContractId(final String header, final Integer key) {

		getTestContext().getRequestHeaders().put(header, getTestContext().getDynamicContractIdByKey(key));
	}

	@Given("^I have the x-timestamp header with current time$")
	public void iHaveTheTimestampHeaderWithCurrentTime() {

		getTestContext().getRequestHeaders().put(TIMESTAMP_HEADER, new Date().getTime());
	}

	@Given("^I have the delivery date header with current date$")
	public void iHaveTheDeliveryDateHeaderWithCurrentDate() {

		getTestContext().getRequestHeaders().put(DELIVERY_DATE_HEADER, dateFormatter(new Date(), VALID_FROM_DATE_FORMAT));
	}

	@Given("^I have the \"([^\"]*)\" param with value \"([^\"]*)\"$")
	public void iHaveTheParamWithValue(final String param, final String value) {

		final String newValue = JsonLoader.applyPlaceHolders(value, getTestContext());
		getTestContext().getRequestParams().put(param, newValue);
	}

	@Given("^I have the \"([^\"]*)\" param with value dynamic account id$")
	public void iHaveTheParamWithValueDynamicAccountId(final String param) {

		getTestContext().getRequestParams().put(param, getTestContext().getDynamicVendorAccountId());
	}

	@Given("^I have the \"([^\"]*)\" param with value dynamic delivery center id$")
	public void iHaveTheParamWithValueDynamicDeliveryCenterId(final String param) {

		getTestContext().getRequestParams().put(param, getTestContext().getDynamicVendorDeliveryCenterId());
	}

	@Given("^I have the \"([^\"]*)\" param with value dynamic contract id$")
	public void iHaveTheParamWithValueDynamicContractId(final String param) {

		getTestContext().getRequestParams().put(param, getTestContext().getDynamicContractId());
	}

	@Given("^I have the \"([^\"]*)\" param with list values$")
	public void iHaveTheParamWithListValues(final String param, final List<String> values) {

		final List<String> newValues = values.stream()
				.map(value -> JsonLoader.applyPlaceHolders(value, getTestContext()))
				.collect(Collectors.toList());

		getTestContext().getRequestParams().put(param, newValues);
	}

	@Given("^I have the enforcement params with \"([^\"]*)\", \"([^\"]*)\", \"([^\"]*)\", \"([^\"]*)\" and \"([^\"]*)\"")
	public void iHaveTheEnforcementParamWithListValues(final Integer accountKey, final Integer enforcementKey, final String vendorId,
			final String entity, final String entityId) {

		final String encodedEnforcement = PlatformIdEncoderDecoderHelper.encodeEnforcement(
				getTestContext().getDynamicVendorAccountIdByKey(accountKey), vendorId, entity, entityId);

		getTestContext().addDynamicEnforcementPlatformIdByKey(enforcementKey, encodedEnforcement);

		final String enforcementPlatformIds = (String) getTestContext().getRequestParams().get("enforcementPlatformIds");

		final StringBuilder sb = new StringBuilder();
		if (Objects.nonNull(enforcementPlatformIds)) {
			sb.append(enforcementPlatformIds);
			sb.append(",");
		}
		sb.append(encodedEnforcement);

		getTestContext().getRequestParams().put("enforcementPlatformIds", sb.toString());
	}

	@Given("^I have the \"([^\"]*)\" param with the list of all contractIds values$")
	public void iHaveTheParamWithListOfContractIdsValues(final String param) {

		final List<String> ids = getTestContext().getAllDynamicContractIdByKey();

		getTestContext().getRequestParams().put(param, ids);
	}

	@Then("^The response code is \"([^\"]*)\" and the body matches the json at file \"([^\"]*)\" at folder \"([^\"]*)\"$")
	public void theResponseMatchesFile(final String statusCode, final String fileName, final String folder) {

		getTestContext().setFolder(folder);
		theResponseMatchesFileComparingMode(statusCode, fileName, folder, JSONCompareMode.NON_EXTENSIBLE);
	}

	@Then("^The response code is \"([^\"]*)\" and the body leniently matches the json at file \"([^\"]*)\" at folder \"([^\"]*)\"$")
	public void theResponseLenientlyMatchesFile(final String statusCode, final String fileName, final String folder) {

		getTestContext().setFolder(folder);
		theResponseMatchesFileComparingMode(statusCode, fileName, folder, JSONCompareMode.LENIENT);
	}

	private void theResponseMatchesFileComparingMode(final String statusCode, final String fileName, final String folder,
			final JSONCompareMode jsonCompareMode) {

		final TestContext testContext = getTestContext();
		final int secondsToAwait = ofNullable(testContext.getCustomSecondsToAwait()).orElse(SECONDS_TO_AWAIT);
		await().pollInterval(POLL_INTERVAL_IN_SECONDS, SECONDS).pollDelay(Duration.ZERO).atMost(secondsToAwait, SECONDS)
				.untilAsserted(() -> {
					final Response response = doRequest(testContext);

					testContext.setResponse(response);

					response.then().log().ifValidationFails(LogDetail.ALL).statusCode(Integer.parseInt(statusCode));

					String actualResponse = response.getBody().asPrettyString();

					if (PayloadHelper.shouldUpdateJsonFile(folder)) {

						final String expectedResponse = PayloadHelper.getResponseDataFileContentAsString(folder, fileName);

						final String actualResponseWithPlaceholders = PayloadHelper.updateFieldsWithPlaceholder(expectedResponse,
								actualResponse);

						writeJsonToFile(folder, fileName, actualResponseWithPlaceholders);
					}

					actualResponse = removeTimeZone(actualResponse);

					actualResponse = removeAccountIdDbIdForSpecificZones(testContext.getCountry(), folder, actualResponse);

					final String expectedResponse = removeTimeZone(getResponseDataFileContentAsString(folder, fileName, testContext));

					LOGGER.debug("Starting assert of response");
					LOGGER.debug("Expected Response: {}", expectedResponse);
					LOGGER.debug("Actual Response: {}", actualResponse);
					JSONAssert.assertEquals(expectedResponse, actualResponse, jsonCompareMode);

				});

		clearRequestData(testContext);
	}

	@Then("^The response code is \"([^\"]*)\" and the body is blank$")
	public void theResponseCodeIsAndTheBodyIsBlank(final String statusCode) {

		final TestContext testContext = getTestContext();
		final int secondsToAwait = ofNullable(testContext.getCustomSecondsToAwait()).orElse(SECONDS_TO_AWAIT);

		await().pollInterval(POLL_INTERVAL_IN_SECONDS, SECONDS).pollDelay(Duration.ZERO).atMost(secondsToAwait, SECONDS)
				.untilAsserted(() -> {
					final Response response = doRequest(testContext);
					testContext.setResponse(response);

					response.then().log().ifValidationFails(LogDetail.ALL).assertThat().statusCode(Integer.parseInt(statusCode));

					final String actualResponse = response.getBody().asString();
					assertThat(actualResponse, is(emptyString()));
				});
		clearRequestData(testContext);
	}

	@And("^I have the requestTraceId header with value starting with a \"([^\"]*)\"$")
	public void iHaveTheRequestTraceIdHeaderWithValueStartingWithA(String requestTraceIdPrefix) {

		final String country = getTestContext().getRequestHeaders().get(COUNTRY_HEADER).toString();
		if (country != null) {
			requestTraceIdPrefix = requestTraceIdPrefix + "-" + country;
		}
		final UUID uuid = UUID.randomUUID();
		final String requestTraceId = requestTraceIdPrefix + "-" + uuid;
		getTestContext().getRequestHeaders().put(REQUEST_TRACE_ID_HEADER, requestTraceId);
	}

	@And("^I have dynamic market place ids$")
	public void IHaveDynamicMarketPlaceIds() {

		final String vendorId = getTestContext().getRequestHeaders().getOrDefault(VENDOR_ID_HEADER, EMPTY).toString();

		if (isNull(getTestContext().getDynamicContractId())) {
			getTestContext().setDynamicContractId(encodeContractId(vendorId, getTestContext().getDynamicVendorAccountId()));
		}

		if (isNull(getTestContext().getDynamicDeliveryCenterPlatformId())) {
			getTestContext().setDynamicDeliveryCenterPlatformId(
					encodeDeliveryCenterId(vendorId, getTestContext().getDynamicVendorDeliveryCenterId()));
		}
	}

	@And("^I have dynamic contract Id for key \"([^\"]*)\" and vendorId \"([^\"]*)\"$")
	public void IHaveDynamicContractIdForVendor(final Integer key, final String vendorId) {

		final String dynamicVendorAccountId = DynamicIdsHelper.getInstance().generateDynamicVendorAccountId(String.valueOf(key));

		getTestContext().addDynamicVendorAccountIdByKey(key, dynamicVendorAccountId);
		getTestContext().addDynamicContractIdByKey(key, encodeContractId(vendorId, dynamicVendorAccountId));
	}

	@And("^I have vendor account id with value \"([^\"]*)\" for key \"([^\"]*)\"$")
	public void IHaveVendorAccountIdForKey(final String vendorAccountId, final Integer key) {

		getTestContext().addDynamicVendorAccountIdByKey(key, vendorAccountId);

	}

	@And("^I have dynamic price list Id for key \"([^\"]*)\"$")
	public void IHaveDynamicPriceListIdForVendor(final Integer key) {

		final String dynamicPriceListId = DynamicIdsHelper.getInstance().generateDynamicPriceListId(String.valueOf(key));

		getTestContext().addDynamicPriceListIdByKey(key, dynamicPriceListId);
	}

	@And("^I have dynamic tax Id for key \"([^\"]*)\"$")
	public void IHaveDynamicTaxIdForVendor(final Integer key) {

		final String dynamicTaxId = DynamicIdsHelper.getInstance().generateDynamicTaxId(String.valueOf(key));

		getTestContext().addDynamicTaxIdByKey(key, dynamicTaxId);
	}

	@And("^I have dynamic delivery Center Id for key \"([^\"]*)\" and vendorId \"([^\"]*)\"$")
	public void IHaveDynamicDeliveryCenterIdForVendor(final Integer key, final String vendorId) {

		final String dynamicVendorDeliveryCenterId = DynamicIdsHelper.getInstance().generateDynamicDeliveryCenterId(String.valueOf(key));

		getTestContext().addDynamicVendorDeliveryCenterIdByKey(key, dynamicVendorDeliveryCenterId);
		getTestContext().addDynamicDeliveryCenterPlatformIdByKey(key, encodeDeliveryCenterId(vendorId, dynamicVendorDeliveryCenterId));
	}

	@And("^I generate the token to the vendorId \"([^\"]*)\"$")
	public void iGenerateTheTokenToTheVendorId(final String vendorId) {

		final String authorization = getGlobalTestContext().getAuthorizationByVendorId(vendorId);

		getTestContext().addAuthorizationByVendorId(vendorId,
				ofNullable(authorization).orElse(GenerateAuthorization.getInstance().execute(ENVIRONMENT_UAT, vendorId)));
	}

	@And("^I set the token to the vendorId \"([^\"]*)\"$")
	public void iSetTheTokenToTheVendorId(final String vendorId) {

		getTestContext().setAuthorization(
				ofNullable(getGlobalTestContext().getAuthorizationByVendorId(vendorId))
						.orElse(getTestContext().getAuthorizationByVendorId(vendorId))
		);
	}

	@And("^I have the \"([^\"]*)\" param with value dynamic beesAccountId$")
	public void iHaveTheParamWithDynamicBeesAccountIdValue(final String param) {

		getTestContext().getRequestParams().put(param, getTestContext().getTaxId());
	}

	@And("^I have the dynamic comboAccountPlatformId param with dynamic vendor account id of key ([^\"]*)$")
	public void iHaveTheDynamicComboAccountPlatformIdParamWithDynamicVendorAccountIdOfKey(final Integer vendorAccountKey) {

		final List<String> comboIds = (List<String>) getTestContext().getRequestHeaders().get("comboIds");
		Integer comboAccountPlatformIdKey = 1;

		for (final String comboId : comboIds) {

			final ComboPlatformId comboPlatformId = (ComboPlatformId) platformIdEncoderDecoder.decodePlatformId(comboId, COMBO);

			final String dynamicComboAccountPlatformId = PlatformIdEncoderDecoderHelper.getComboAccountPlatformId(
					comboPlatformId.getVendorId(), getTestContext().getDynamicVendorAccountIdByKey(vendorAccountKey),
					comboPlatformId.getComboId());

			getTestContext().addDynamicComboAccountPlatformIdByKey(comboAccountPlatformIdKey, dynamicComboAccountPlatformId);
			comboAccountPlatformIdKey++;
		}
		getTestContext().getRequestParams().put("comboAccountPlatformIds", getTestContext().getAllDynamicComboAccountPlatformIds());
	}

	@And("^I have combo account platform Id for key \"([^\"]*)\" with comboId \"([^\"]*)\" and vendorId \"([^\"]*)\"$")
	public void iHaveTheComboAccountPlatformIdParamWithComboIdAndVendorIdForKey(final Integer key, final String comboId,
			final String vendorId) {

		final String dynamicComboAccountPlatformId = PlatformIdEncoderDecoderHelper.getComboAccountPlatformId(
				vendorId, getTestContext().getDynamicVendorAccountIdByKey(1), comboId);
		getTestContext().addDynamicComboAccountPlatformIdByKey(key, dynamicComboAccountPlatformId);
	}

	@And("^I have combo delivery center platform Id for key \"([^\"]*)\" with comboId \"([^\"]*)\" and vendorId \"([^\"]*)\"$")
	public void iHaveTheComboDeliveryCenterPlatformIdParamWithComboIdAndVendorIdForKey(final Integer key, final String comboId,
			final String vendorId) {

		final String dynamicComboDeliveryCenterPlatformId = PlatformIdEncoderDecoderHelper.getComboDeliveryCenterPlatformId(
				vendorId, getTestContext().getDynamicVendorDeliveryCenterIdByKey(1), comboId);
		getTestContext().addDynamicComboDeliveryCenterPlatformIdByKey(key, dynamicComboDeliveryCenterPlatformId);
	}

	@And("^I have the platformsIds with comboIds done$")
	public void handleValueParamInLine() {

		if (Objects.nonNull(getTestContext().getAllDynamicComboAccountPlatformIds())) {
			final List<String> dynamicComboAccountPlatformIds = getTestContext().getAllDynamicComboAccountPlatformIds();

			final StringBuilder stringBuilder = new StringBuilder();

			for (final String comboAccountPlatformId : dynamicComboAccountPlatformIds) {
				stringBuilder.append(comboAccountPlatformId);
				stringBuilder.append(SEPARATOR);
			}
			String toHandleComma = stringBuilder.toString();
			if (toHandleComma.length() != 0) {
				toHandleComma = toHandleComma.substring(0, toHandleComma.length() - SEPARATOR.length());
				getTestContext().getRequestParams().put("comboAccountPlatformIds", toHandleComma);
			}
		}
		if (Objects.nonNull(getTestContext().getAllDynamicComboDeliveryCenterPlatformIds())) {
			final List<String> dynamicComboDeliveryCenterPlatformIds = getTestContext().getAllDynamicComboDeliveryCenterPlatformIds();

			final StringBuilder stringBuilder = new StringBuilder();

			for (final String comboDeliveryCenterPlatformId : dynamicComboDeliveryCenterPlatformIds) {
				stringBuilder.append(comboDeliveryCenterPlatformId);
				stringBuilder.append(SEPARATOR);
			}
			String toHandleComma = stringBuilder.toString();
			if (toHandleComma.length() != 0) {
				toHandleComma = toHandleComma.substring(0, toHandleComma.length() - SEPARATOR.length());

				getTestContext().getRequestParams().put("comboDeliveryCenterPlatformIds", toHandleComma);
			}
		}
	}

	@After
	public void afterScenario(final Scenario scenario) {

		if (scenario.isFailed()) {
			final TestContext testContext = getTestContext();

			LOGGER.info(String.format("Scenario failed: %s", testContext.getRequestHeaders().get("requestTraceId")));
		}
	}

	private String removeTimeZone(final String payload) {

		return payload.replaceAll(REMOVE_TIME_ZONE_REGEX, StringUtils.EMPTY);
	}

	private String removeAccountIdDbIdForSpecificZones(final String country, final String folder, final String payload) {

		if (country.equalsIgnoreCase("MX") && folder.equalsIgnoreCase("account-service")) {
			return payload.replaceAll(REMOVE_ACCOUNT_ID_DB_ID_REGEX, StringUtils.EMPTY);
		} else {
			return payload;
		}
	}

	@And("^I have vendorId \"([^\"]*)\" for key \"([^\"]*)\"$")
	public void iHaveEncodedItemIdForVendor(final String vendorId, final String key) {

		getTestContext().addVendorIdByKey(key, vendorId);
	}
}
