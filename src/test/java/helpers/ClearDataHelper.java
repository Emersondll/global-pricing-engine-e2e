package helpers;

import static configs.EnvironmentConfig.runAccountServiceLocally;
import static configs.EnvironmentConfig.runChargeServiceLocally;
import static configs.EnvironmentConfig.runComboServiceLocally;
import static configs.EnvironmentConfig.runDealServiceLocally;
import static configs.EnvironmentConfig.runItemServiceLocally;
import static configs.EnvironmentConfig.runPriceServiceLocally;
import static configs.EnvironmentConstants.LOCAL_ACCOUNT_API_ENDPOINT_V1;
import static configs.EnvironmentConstants.LOCAL_CHARGE_API_ENDPOINT_V2;
import static configs.EnvironmentConstants.LOCAL_CHARGE_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.LOCAL_COMBO_API_ENDPOINT_V3;
import static configs.EnvironmentConstants.LOCAL_COMBO_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.LOCAL_COMBO_SCORE_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.LOCAL_DEAL_API_ENDPOINT_V2;
import static configs.EnvironmentConstants.LOCAL_DEAL_API_ENDPOINT_V3;
import static configs.EnvironmentConstants.LOCAL_DEAL_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.LOCAL_DELETE_ACCOUNT_RELAY_ENDPOINT_V1;
import static configs.EnvironmentConstants.LOCAL_DELETE_ITEM_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.LOCAL_ITEM_API_ENDPOINT_V1;
import static configs.EnvironmentConstants.LOCAL_PRICE_API_ENDPOINT_V2;
import static configs.EnvironmentConstants.LOCAL_PRICE_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.LOCAL_PRICE_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.POLL_INTERVAL_IN_SECONDS;
import static configs.EnvironmentConstants.SECONDS_TO_AWAIT_ON_CLEAR_PROCESS;
import static configs.EnvironmentConstants.UAT_ACCOUNT_API_ENDPOINT_V1;
import static configs.EnvironmentConstants.UAT_CHARGE_API_ENDPOINT_V2;
import static configs.EnvironmentConstants.UAT_CHARGE_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.UAT_COMBO_API_ENDPOINT_V3;
import static configs.EnvironmentConstants.UAT_COMBO_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.UAT_COMBO_SCORE_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.UAT_DEAL_API_ENDPOINT_V2;
import static configs.EnvironmentConstants.UAT_DEAL_API_ENDPOINT_V3;
import static configs.EnvironmentConstants.UAT_DEAL_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.UAT_DELETE_ACCOUNT_RELAY_ENDPOINT_V1;
import static configs.EnvironmentConstants.UAT_DELETE_ITEM_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.UAT_ITEM_API_ENDPOINT_V1;
import static configs.EnvironmentConstants.UAT_PRICE_API_ENDPOINT_V2;
import static configs.EnvironmentConstants.UAT_PRICE_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.UAT_PRICE_RELAY_ENDPOINT_V3;
import static helpers.JsonLoader.getRequestDataFileContentAsString;
import static helpers.JsonLoader.getResponseDataFileContentAsString;
import static helpers.TestConstants.ACCOUNT_ID_PATH;
import static helpers.TestConstants.APPLICATION_JSON;
import static helpers.TestConstants.AUTHORIZATION_HEADER;
import static helpers.TestConstants.CONTENT_TYPE_HEADER;
import static helpers.TestConstants.COUNTRY_HEADER;
import static helpers.TestConstants.PRICE_LIST_ID_HEADER;
import static helpers.TestConstants.REQUEST_TRACE_ID_HEADER;
import static helpers.TestConstants.TIMESTAMP_HEADER;
import static helpers.TestConstants.TIMEZONE_HEADER;
import static helpers.TestConstants.TRACE_ID;
import static helpers.TestConstants.VENDOR_ACCOUNT_ID_HEADER;
import static helpers.TestConstants.VENDOR_ACCOUNT_ID_PARAMETER;
import static helpers.TestConstants.VENDOR_ID;
import static helpers.TestConstants.VENDOR_ID_HEADER;
import static helpers.TestConstants.VENDOR_ITEM_IDS_PATH;
import static io.restassured.RestAssured.given;
import static java.util.Objects.nonNull;
import static java.util.UUID.randomUUID;
import static java.util.concurrent.TimeUnit.SECONDS;
import static org.apache.commons.lang3.ObjectUtils.isNotEmpty;
import static org.apache.commons.lang3.StringUtils.isNotEmpty;
import static org.awaitility.Awaitility.await;

import java.io.IOException;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.IntStream;

import org.apache.http.HttpStatus;
import org.skyscreamer.jsonassert.JSONAssert;
import org.skyscreamer.jsonassert.JSONCompareMode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.collect.Lists;
import com.jayway.jsonpath.JsonPath;

import context.DataCreatedInTestContext;
import context.TestContext;
import context.TestContextService;
import io.restassured.filter.log.LogDetail;
import io.restassured.http.Method;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import net.minidev.json.JSONArray;

public class ClearDataHelper {

	private static final Logger LOGGER = LoggerFactory.getLogger(ClearDataHelper.class);
	private static final ClearDataHelper INSTANCE = new ClearDataHelper();

	private ClearDataHelper() {

	}

	public static ClearDataHelper getInstance() {

		return INSTANCE;
	}

	public void clearDataBase(final String token, final String dynamicVendorAccountId, final String dynamicPriceList, final String country,
			final DataCreatedInTestContext dataCreatedInTestContext, final boolean shouldValidateDeletion) {

		LOGGER.info("=== Starting to clear database ===");

		LOGGER.info("Clearing vendorAccountId: {}", dynamicVendorAccountId);
		LOGGER.info("Clearing priceListId: {}", dynamicPriceList);

		Collections.singletonList(country).forEach(countryToDelete -> {

			final List<String> vendorAccountIds = Collections.singletonList(dynamicVendorAccountId);
			final List<String> priceListIds = Collections.singletonList(dynamicPriceList);

			LOGGER.info(String.format("=== Clearing data of the country: %s ===", countryToDelete));

			final List<String> vendorItemIds = getAllVendorItemIdsForTheAccount(token, countryToDelete, vendorAccountIds,
					dataCreatedInTestContext);
			vendorItemIds.addAll(getAllVendorItemIdsForThePriceList(token, countryToDelete, vendorAccountIds, priceListIds,
					dataCreatedInTestContext));

			final List<String> vendorDealIds = getAllVendorDealIdForTheAccount(token, countryToDelete, vendorAccountIds,
					dataCreatedInTestContext);

			final List<String> vendorChargeIds = getAllVendorChargeIdsForTheAccount(token, countryToDelete, vendorAccountIds,
					dataCreatedInTestContext);

			final List<String> vendorComboIds = getAllVendorComboIdForTheAccount(token, countryToDelete.toUpperCase(), vendorAccountIds,
					dataCreatedInTestContext);

			//final List<String> itemVendorItemIds = getAllVendorItemIdsForTheVendor(token, countryToDelete);

			deleteAll(token, countryToDelete, vendorItemIds, vendorDealIds, vendorChargeIds, vendorComboIds,
					/*itemVendorItemIds,*/ vendorAccountIds, priceListIds);

			validateAll(token, shouldValidateDeletion, countryToDelete, vendorItemIds, vendorDealIds, vendorChargeIds, vendorComboIds,
					/*itemVendorItemIds,*/ vendorAccountIds);

			LOGGER.info(String.format("=== End clearing data of the country: %s ===", countryToDelete));
		});

		LOGGER.info("=== Finish to clear database ===");
	}

	private void deleteAll(final String token, final String country, final List<String> vendorItemIds,
			final List<String> vendorDealIds, final List<String> vendorChargeIds, final List<String> vendorComboIds,
			/*final List<String> itemVendorItemIds,*/ final List<String> vendorAccountIds, final List<String> priceListIds) {

		try {
			if (isNotEmpty(vendorItemIds)) {
				deletePrices(vendorAccountIds, vendorItemIds, token, country);
				deletePriceList(priceListIds, vendorItemIds, token, country);
			}
		} catch (final Throwable e) {
			LOGGER.error(String.format("Error while deleting prices from e2e data for country %s", country), e);
			throw new RuntimeException(e);
		}

		try {
			if (isNotEmpty(vendorDealIds)) {
				deleteDeals(vendorAccountIds, vendorDealIds, token, country);
			}
		} catch (final Throwable e) {
			LOGGER.error(String.format("Error while deleting deals from e2e data for country %s", country), e);
			throw new RuntimeException(e);
		}

		try {
			if (isNotEmpty(vendorChargeIds)) {
				deleteCharges(vendorAccountIds, vendorChargeIds, token, country);
			}
		} catch (final Throwable e) {
			LOGGER.error(String.format("Error while deleting charges from e2e data for country %s", country), e);
			throw new RuntimeException(e);
		}

		try {
			if (nonNull(vendorComboIds) && !vendorComboIds.isEmpty()) {
				deleteCombos(vendorAccountIds, vendorComboIds, token, country);
			}
		} catch (final Throwable e) {
			LOGGER.error(String.format("Error while deleting combos from e2e data for country %s", country), e);
			throw new RuntimeException(e);
		}
		// Commented again as was done in the 206 line
		// It is not necessary to delete, because the itemVendorItemIds are fixed.
		//		try {
		//			if (nonNull(vendorItemIds) && !vendorItemIds.isEmpty()) {
		//				deleteItems(vendorItemIds, token, country);
		//			}
		//		} catch (final Throwable e) {
		//			LOGGER.error(String.format("Error while deleting items from e2e data for country %s", country), e);
		//			throw new RuntimeException(e);
		//		}

		try {
			deleteAccounts(vendorAccountIds, token, country);
		} catch (final Throwable e) {
			LOGGER.error(String.format("Error while deleting accounts from e2e data for country %s", country), e);
			throw new RuntimeException(e);
		}

		// It is not necessary to delete, because the itemVendorItemIds are fixed.
		//		try {
		//			if (isNotEmpty(itemVendorItemIds)) {
		//				deleteItems(itemVendorItemIds, token, country);
		//			}
		//		} catch (final Throwable e) {
		//			LOGGER.error(String.format("Error while deleting items from e2e data for country %s", country), e);
		//			throw new RuntimeException(e);
		//		}
	}

	private void validateAll(final String token, final boolean shouldValidateDeletion, final String country,
			final List<String> vendorItemIds, final List<String> vendorDealIds, final List<String> vendorChargeIds,
			final List<String> vendorComboIds, /*final List<String> itemVendorItemIds,*/ final List<String> vendorAccountIds) {

		final List<Runnable> validateSteps = new ArrayList<>();
		validateSteps.add(() -> {
			try {
				if (isNotEmpty(vendorItemIds)) {
					validateDeletion(shouldValidateDeletion, token, country,
							runPriceServiceLocally() ? LOCAL_PRICE_API_ENDPOINT_V2 : UAT_PRICE_API_ENDPOINT_V2, "prices", vendorAccountIds);
				}
			} catch (final Throwable e) {
				LOGGER.error(String.format("Error while validating deleting prices from e2e data for country %s", country), e);
				throw new RuntimeException(e);
			}
		});

		validateSteps.add(() -> {
			try {
				if (isNotEmpty(vendorDealIds)) {
					validateDeletion(shouldValidateDeletion, token, country,
							runDealServiceLocally() ? LOCAL_DEAL_API_ENDPOINT_V2 : UAT_DEAL_API_ENDPOINT_V2, "deals", vendorAccountIds);
				}
			} catch (final Throwable e) {
				LOGGER.error(String.format("Error while validating deleting deals from e2e data for country %s", country), e);
				throw new RuntimeException(e);
			}
		});

		validateSteps.add(() -> {
			try {
				if (isNotEmpty(vendorChargeIds)) {
					validateDeletion(shouldValidateDeletion, token, country,
							runChargeServiceLocally() ? LOCAL_CHARGE_API_ENDPOINT_V2 : UAT_CHARGE_API_ENDPOINT_V2, "charges",
							vendorAccountIds);
				}
			} catch (final Throwable e) {
				LOGGER.error(String.format("Error while validating deleting charges from e2e data for country %s", country), e);
				throw new RuntimeException(e);
			}
		});

		validateSteps.add(() -> {
			try {
				if (nonNull(vendorComboIds) && !vendorComboIds.isEmpty()) {
					validateDeletionForCombos(shouldValidateDeletion, token, country,
							runComboServiceLocally() ? LOCAL_COMBO_API_ENDPOINT_V3 : UAT_COMBO_API_ENDPOINT_V3, vendorAccountIds);
				}
			} catch (final Throwable e) {
				LOGGER.error(String.format("Error while validating deleting combos from e2e data for country %s", country), e);
				throw new RuntimeException(e);
			}
		});

		validateSteps.add(() -> {
			try {
				validateAccountDeletion(shouldValidateDeletion, token, country,
						runAccountServiceLocally() ? LOCAL_ACCOUNT_API_ENDPOINT_V1 : UAT_ACCOUNT_API_ENDPOINT_V1, vendorAccountIds);
			} catch (final Throwable e) {
				LOGGER.error(String.format("Error while validating deleting accounts from e2e data for country %s", country), e);
				throw new RuntimeException(e);
			}
		});

		//		validateSteps.add(() -> {
		//			try {
		//				if (isNotEmpty(itemVendorItemIds)) {
		//					validateItemDeletion(shouldValidateDeletion, token, country,
		//							runItemServiceLocally() ? LOCAL_ITEM_API_ENDPOINT_V1 : UAT_ITEM_API_ENDPOINT_V1);
		//				}
		//			} catch (final Throwable e) {
		//				LOGGER.error(String.format("Error while validating deleting items from e2e data for country %s", country), e);
		//				throw new RuntimeException(e);
		//			}
		//		});

		validateSteps.parallelStream().forEach(Runnable::run);
	}

	private void deletePrices(final List<String> vendorAccountIds, final List<String> vendorItemIds, final String token,
			final String country) throws IOException {

		LOGGER.info(String.format("=== Deleting prices of country %s ===", country));

		final String deletePricePayloadTemplate = getRequestDataFileContentAsString("price-service", "delete-prices-payload-template");

		final LinkedHashMap<String, Object> payload = generateDeletePayload(vendorAccountIds, vendorItemIds, deletePricePayloadTemplate,
				"vendorAccountIds", "vendorItemIds");

		deleteRequest(token, country, payload, runPriceServiceLocally() ? LOCAL_PRICE_RELAY_ENDPOINT_V2 : UAT_PRICE_RELAY_ENDPOINT_V2,
				null);

	}

	private void deletePriceList(final List<String> priceListIds, final List<String> vendorItemIds, final String token,
			final String country) throws IOException {

		LOGGER.info(String.format("=== Deleting price list of country %s ===", country));

		final String deletePriceListPayloadTemplate = getRequestDataFileContentAsString("price-service",
				"delete-price-list-payload-template");

		final LinkedHashMap<String, Object> payload = generateDeletePayload(priceListIds, vendorItemIds, deletePriceListPayloadTemplate,
				"ids", "vendorItemIds");

		deleteRequest(token, country, payload, runPriceServiceLocally() ? LOCAL_PRICE_RELAY_ENDPOINT_V3 : UAT_PRICE_RELAY_ENDPOINT_V3,
				null);

	}

	private void deleteDeals(final List<String> vendorAccountIds, final List<String> vendorDealIds, final String token,
			final String country) throws IOException {

		LOGGER.info(String.format("=== Deleting deals of country %s ===", country));

		final String deleteDealPayloadTemplate = getRequestDataFileContentAsString("deal-service", "delete-deals-payload-template");

		final LinkedHashMap<String, Object> payload = generateDeletePayload(vendorAccountIds, vendorDealIds, deleteDealPayloadTemplate,
				"vendorAccountIds", "vendorDealIds");

		deleteRequest(token, country, payload, runDealServiceLocally() ? LOCAL_DEAL_RELAY_ENDPOINT_V2 : UAT_DEAL_RELAY_ENDPOINT_V2, null);
	}

	private void deleteCharges(final List<String> vendorAccountIds, final List<String> vendorChargeIds, final String token,
			final String country) throws IOException {

		LOGGER.info(String.format("=== Deleting charges of country %s ===", country));

		final String deleteChargePayloadTemplate = getRequestDataFileContentAsString("charge-service", "delete-charges-payload-template");

		final LinkedHashMap<String, Object> payload = generateDeletePayload(vendorAccountIds, vendorChargeIds, deleteChargePayloadTemplate,
				"vendorAccountIds", "vendorChargeIds");

		deleteRequest(token, country, payload, runChargeServiceLocally() ? LOCAL_CHARGE_RELAY_ENDPOINT_V2 : UAT_CHARGE_RELAY_ENDPOINT_V2,
				null);
	}

	private void deleteAccounts(final List<String> vendorAccountIds, final String token, final String country) {

		LOGGER.info(String.format("=== Deleting accounts of country %s ===", country));

		for (final String vendorAccountId : vendorAccountIds) {
			final Map<String, Object> pathParams = new HashMap<>();
			pathParams.put(ACCOUNT_ID_PATH, vendorAccountId);

			deleteRequest(token, country, null,
					runChargeServiceLocally() ? LOCAL_DELETE_ACCOUNT_RELAY_ENDPOINT_V1 : UAT_DELETE_ACCOUNT_RELAY_ENDPOINT_V1, pathParams);
		}
	}

	private void deleteCombos(final List<String> vendorAccountIds, final List<String> vendorComboIds, final String token,
			final String country) throws IOException {

		LOGGER.info(String.format("=== Deleting combos of country %s ===", country));

		final String deleteComboPayloadTemplate = getRequestDataFileContentAsString("combo-service", "delete-combos-payload-template");

		final LinkedHashMap<String, Object> payload = generateDeletePayload(vendorAccountIds, vendorComboIds, deleteComboPayloadTemplate,
				"vendorAccountIds", "vendorComboIds");

		deleteRequest(token, country, payload, runComboServiceLocally() ? LOCAL_COMBO_RELAY_ENDPOINT_V3 : UAT_COMBO_RELAY_ENDPOINT_V3,
				null);
	}

	private void deleteItems(final List<String> vendorItemIdsList, final String token, final String country) {

		LOGGER.info(String.format("=== Deleting items of country %s ===", country));

		Lists.partition(vendorItemIdsList, 10).parallelStream().forEach(vendorItemIdsPartition -> {

			final String vendorItemIds = String.join(",", vendorItemIdsPartition);
			final Map<String, Object> pathParams = new HashMap<>();
			pathParams.put(VENDOR_ITEM_IDS_PATH, vendorItemIds);

			deleteRequest(token, country, null,
					runItemServiceLocally() ? LOCAL_DELETE_ITEM_RELAY_ENDPOINT_V2 : UAT_DELETE_ITEM_RELAY_ENDPOINT_V2, pathParams);
		});
	}

	private List<String> getAllVendorItemIdsForTheAccount(final String token, final String country, final List<String> vendorAccountIds,
			final DataCreatedInTestContext dataCreatedInTestContext) {

		LOGGER.info(String.format("=== Getting price vendor item ids for %s ===", country));

		final List<String> vendorItemIds = Collections.synchronizedList(new ArrayList<>());

		if (dataCreatedInTestContext.getDataCreatedInPriceRelayV2() || dataCreatedInTestContext.getDataCreatedInPriceRelayV3()) {
			vendorAccountIds.parallelStream().forEach(vendorAccountId -> {

				await().pollInterval(POLL_INTERVAL_IN_SECONDS, SECONDS).pollDelay(Duration.ZERO)
						.atMost(SECONDS_TO_AWAIT_ON_CLEAR_PROCESS, SECONDS).untilAsserted(() -> {
							final Response response = getRequest(token, country, vendorAccountId,
									runPriceServiceLocally() ? LOCAL_PRICE_API_ENDPOINT_V2 : UAT_PRICE_API_ENDPOINT_V2);

							if (response.getStatusCode() == HttpStatus.SC_OK) {
								vendorItemIds.addAll(extractValuesFromResponse(response, "$.prices", "vendorItemId"));
							}
						});
			});
		}

		return vendorItemIds;
	}

	private List<String> getAllVendorItemIdsForThePriceList(final String token, final String country, final List<String> vendorAccountIds,
			final List<String> priceListIds, final DataCreatedInTestContext dataCreatedInTestContext) {

		LOGGER.info(String.format("=== Getting price vendor item ids for %s ===", country));

		final List<String> vendorItemIds = Collections.synchronizedList(new ArrayList<>());

		if (dataCreatedInTestContext.getDataCreatedInPriceRelayV2()) {
			IntStream.range(0, priceListIds.size()).parallel().forEach(index -> {
				final String priceListId = priceListIds.get(index);
				final String vendorAccountId = vendorAccountIds.get(index);

				await().pollInterval(POLL_INTERVAL_IN_SECONDS, SECONDS).pollDelay(Duration.ZERO)
						.atMost(SECONDS_TO_AWAIT_ON_CLEAR_PROCESS, SECONDS).untilAsserted(() -> {
							final Response response = getRequest(token, country, vendorAccountId,
									runPriceServiceLocally() ? LOCAL_PRICE_API_ENDPOINT_V2 : UAT_PRICE_API_ENDPOINT_V2, null, priceListId);

							if (response.getStatusCode() == HttpStatus.SC_OK) {
								vendorItemIds.addAll(extractValuesFromResponse(response, "$.prices", "vendorItemId"));
							}
						});
			});
		}

		return vendorItemIds;
	}

	private List<String> getAllVendorDealIdForTheAccount(final String token, final String country, final List<String> vendorAccountIds,
			final DataCreatedInTestContext dataCreatedInTestContext) {

		LOGGER.info(String.format("=== Getting vendor deal ids for %s ===", country));

		final List<String> vendorDealIds = Collections.synchronizedList(new ArrayList<>());

		if (dataCreatedInTestContext.getDataCreatedInDealRelayV2()) {
			vendorAccountIds.parallelStream().forEach(vendorAccountId -> {

				await().pollInterval(POLL_INTERVAL_IN_SECONDS, SECONDS).pollDelay(Duration.ZERO)
						.atMost(SECONDS_TO_AWAIT_ON_CLEAR_PROCESS, SECONDS).untilAsserted(() -> {
							final Response response = getRequest(token, country, vendorAccountId,
									runDealServiceLocally() ? LOCAL_DEAL_API_ENDPOINT_V2 : UAT_DEAL_API_ENDPOINT_V2);

							if (response.getStatusCode() == HttpStatus.SC_OK) {
								vendorDealIds.addAll(extractValuesFromResponse(response, "$.deals", "vendorDealId"));
							}
						});
			});
		}

		if (dataCreatedInTestContext.getDataCreatedInDealRelayV3()) {
			vendorAccountIds.parallelStream().forEach(vendorAccountId -> {

				await().pollInterval(POLL_INTERVAL_IN_SECONDS, SECONDS).pollDelay(Duration.ZERO)
						.atMost(SECONDS_TO_AWAIT_ON_CLEAR_PROCESS, SECONDS)
						.untilAsserted(() -> {
							final Response response = getRequest(token, country, vendorAccountId,
									runDealServiceLocally() ? LOCAL_DEAL_API_ENDPOINT_V3 : UAT_DEAL_API_ENDPOINT_V3);

							if (response.getStatusCode() == HttpStatus.SC_OK) {
								vendorDealIds.addAll(extractValuesFromResponse(response, "$.deals", "vendorDealId"));
							}
						});
			});
		}

		return vendorDealIds;

	}

	private List<String> getAllVendorChargeIdsForTheAccount(final String token, final String country, final List<String> vendorAccountIds,
			final DataCreatedInTestContext dataCreatedInTestContext) {

		LOGGER.info(String.format("=== Getting vendor charge ids for %s ===", country));

		final List<String> vendorChargeIds = Collections.synchronizedList(new ArrayList<>());

		if (dataCreatedInTestContext.getDataCreatedInChargeRelayV2()) {
			vendorAccountIds.parallelStream().forEach(vendorAccountId -> {

				await().pollInterval(POLL_INTERVAL_IN_SECONDS, SECONDS).pollDelay(Duration.ZERO)
						.atMost(SECONDS_TO_AWAIT_ON_CLEAR_PROCESS, SECONDS)
						.untilAsserted(() -> {
							final Response response = getRequest(token, country, vendorAccountId,
									runChargeServiceLocally() ? LOCAL_CHARGE_API_ENDPOINT_V2 : UAT_CHARGE_API_ENDPOINT_V2);

							if (response.getStatusCode() == HttpStatus.SC_OK) {
								vendorChargeIds.addAll(extractValuesFromResponse(response, "$.charges", "vendorChargeId"));
							}
						});
			});
		}

		return vendorChargeIds;

	}

	private List<String> getAllVendorComboIdForTheAccount(final String token, final String country, final List<String> vendorAccountIds,
			final DataCreatedInTestContext dataCreatedInTestContext) {

		LOGGER.info(String.format("=== Getting vendor combo ids for %s ===", country));

		final List<String> vendorComboIds = Collections.synchronizedList(new ArrayList<>());

		if (dataCreatedInTestContext.getDataCreatedInComboRelayV3()) {
			vendorAccountIds.parallelStream().forEach(vendorAccountId -> {
				final Map<String, Object> params = createParams(vendorAccountId);

				await().pollInterval(POLL_INTERVAL_IN_SECONDS, SECONDS).pollDelay(Duration.ZERO)
						.atMost(SECONDS_TO_AWAIT_ON_CLEAR_PROCESS, SECONDS)
						.untilAsserted(() -> {
							final Response response = getRequest(token, country, null,
									runComboServiceLocally() ? LOCAL_COMBO_API_ENDPOINT_V3 : UAT_COMBO_API_ENDPOINT_V3, params, null);

							if (response.getStatusCode() == HttpStatus.SC_OK) {
								vendorComboIds.addAll(extractValuesFromResponse(response, "$.combos", "vendorComboId"));
							}
						});
			});
		}

		if (dataCreatedInTestContext.getDataCreatedInComboScoreRelayV3()) {
			vendorAccountIds.parallelStream().forEach(vendorAccountId -> {
				final Map<String, Object> params = createParams(vendorAccountId);

				await().pollInterval(POLL_INTERVAL_IN_SECONDS, SECONDS).pollDelay(Duration.ZERO)
						.atMost(SECONDS_TO_AWAIT_ON_CLEAR_PROCESS, SECONDS)
						.untilAsserted(() -> {
							final Response response = getRequest(token, country, null,
									runComboServiceLocally() ? LOCAL_COMBO_SCORE_RELAY_ENDPOINT_V3 : UAT_COMBO_SCORE_RELAY_ENDPOINT_V3,
									params, null);

							if (response.getStatusCode() == HttpStatus.SC_OK) {
								vendorComboIds.addAll(extractValuesFromResponse(response, "$.combos", "vendorComboId"));
							}
						});
			});
		}

		return vendorComboIds;
	}

	private Map<String, Object> createParams(final String vendorAccountId) {

		final Map<String, Object> params = new HashMap<>();

		if (isNotEmpty(vendorAccountId)) {
			params.put(VENDOR_ACCOUNT_ID_PARAMETER, vendorAccountId);
		}

		return params;
	}

	private List<String> getAllVendorItemIdsForTheVendor(final String token, final String country) {

		LOGGER.info("=== Getting vendor item ids ===");

		final List<String> vendorItemIds = new ArrayList<>();
		final Map<String, Object> params = new HashMap<>();
		params.put(VENDOR_ID_HEADER, VENDOR_ID);

		await().pollInterval(POLL_INTERVAL_IN_SECONDS, SECONDS).pollDelay(Duration.ZERO).atMost(SECONDS_TO_AWAIT_ON_CLEAR_PROCESS, SECONDS)
				.untilAsserted(() -> {
					final Response response = getRequest(token, country, null,
							runItemServiceLocally() ? LOCAL_ITEM_API_ENDPOINT_V1 : UAT_ITEM_API_ENDPOINT_V1, params, null);

					if (response.getStatusCode() == HttpStatus.SC_OK) {
						vendorItemIds.addAll(extractValuesFromResponse(response, "$.items[*].sourceData", "vendorItemId"));
					}
				});

		return vendorItemIds;

	}

	private void deleteRequest(final String token, final String country, final LinkedHashMap<String, Object> payload, final String endpoint,
			final Map<String, Object> pathParams) {

		final Map<String, Object> headers = new HashMap<>();
		headers.put(COUNTRY_HEADER, country.toUpperCase());
		headers.put(TIMESTAMP_HEADER, String.valueOf(new Date().getTime()));
		headers.put(REQUEST_TRACE_ID_HEADER, String.format(TRACE_ID, randomUUID().toString()));
		headers.put(TIMEZONE_HEADER, TimeZoneHelper.getTimeZoneByCountry(country));
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		final Response response = doRequest(headers, null, token, payload, Method.DELETE, endpoint, pathParams);
		response.then().log().ifValidationFails(LogDetail.ALL).assertThat().statusCode(202);
	}

	private Response getRequest(final String authorization, final String country, final String vendorAccountId, final String endpoint,
			final Map<String, Object> params, final String priceListId) {

		final Map<String, Object> headers = new HashMap<>();
		headers.put(COUNTRY_HEADER, country);
		headers.put(VENDOR_ID_HEADER, VENDOR_ID);
		headers.put(VENDOR_ACCOUNT_ID_HEADER, vendorAccountId);
		headers.put(REQUEST_TRACE_ID_HEADER, String.format(TRACE_ID, randomUUID().toString()));
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);
		headers.put(PRICE_LIST_ID_HEADER, priceListId);

		return doRequest(headers, params, authorization, null, Method.GET, endpoint, null);
	}

	private Response getRequest(final String authorization, final String country, final String vendorAccountId, final String endpoint) {

		return getRequest(authorization, country, vendorAccountId, endpoint, null, null);
	}

	private Response doRequest(final Map<String, Object> headers, final Map<String, Object> params, final String authorization,
			final LinkedHashMap<String, Object> body, final Method method, final String endpoint, final Map<String, Object> pathParams) {

		final RequestSpecification request = given();
		if (isNotEmpty(body)) {
			request.body(body);
		}
		if (isNotEmpty(headers)) {
			request.headers(headers);
		}
		if (isNotEmpty(params)) {
			request.params(params);
		}
		if (isNotEmpty(authorization)) {
			request.header(AUTHORIZATION_HEADER, authorization);
		}
		if (isNotEmpty(pathParams)) {
			request.pathParams(pathParams);
		}

		return request.when().request(method, endpoint);
	}

	private void validateDeletion(final boolean shouldValidate, final String token, final String country, final String endpoint,
			final String type, final List<String> vendorAccountIds) {

		if (shouldValidate) {
			LOGGER.info(String.format("=== Validating the deletion of %s for %s ===", type, country));
			vendorAccountIds.parallelStream().forEach(vendorAccountId -> {
				await().pollInterval(POLL_INTERVAL_IN_SECONDS, SECONDS).pollDelay(Duration.ZERO)
						.atMost(SECONDS_TO_AWAIT_ON_CLEAR_PROCESS, SECONDS)
						.untilAsserted(() -> {
							final Response response = getRequest(token, country, vendorAccountId, endpoint);

							response.then().log().ifValidationFails(LogDetail.ALL).statusCode(HttpStatus.SC_NOT_FOUND);
						});
			});
		}
	}

	private void validateDeletionForCombos(final boolean shouldValidate, final String token, final String country, final String endpoint,
			final List<String> vendorAccountIds) {

		if (shouldValidate) {
			final TestContext testContext = TestContextService.getInstance().getTestContext();
			vendorAccountIds.parallelStream().forEach(vendorAccountId -> {
				LOGGER.info(String.format("=== Validating the deletion of combos for %s ===", country));
				await().pollInterval(POLL_INTERVAL_IN_SECONDS, SECONDS).pollDelay(Duration.ZERO)
						.atMost(SECONDS_TO_AWAIT_ON_CLEAR_PROCESS, SECONDS)
						.untilAsserted(() -> {
							final Response response = getRequest(token, country, vendorAccountId, endpoint, createParams(vendorAccountId),
									null);

							response.then().log().ifValidationFails(LogDetail.ALL).statusCode(HttpStatus.SC_OK);

							final String actualResponse = response.getBody().asString();

							final String expectedResponse = getResponseDataFileContentAsString("combo-service",
									"deleted-combo-expected-template",
									testContext);

							JSONAssert.assertEquals(actualResponse, expectedResponse, actualResponse, JSONCompareMode.LENIENT);
						});
			});
		}

	}

	private void validateAccountDeletion(final boolean shouldValidate, final String token, final String country, final String endpoint,
			final List<String> vendorAccountIds) {

		if (shouldValidate) {
			LOGGER.info(String.format("=== Validating the account deletion for %s ===", country));
			vendorAccountIds.parallelStream().forEach(vendorAccountId -> {
				final Map<String, Object> queryParams = new HashMap<>();
				queryParams.put(VENDOR_ACCOUNT_ID_HEADER, vendorAccountId);
				queryParams.put(VENDOR_ID_HEADER, VENDOR_ID);

				await().pollInterval(POLL_INTERVAL_IN_SECONDS, SECONDS).pollDelay(Duration.ZERO)
						.atMost(SECONDS_TO_AWAIT_ON_CLEAR_PROCESS, SECONDS)
						.untilAsserted(() -> {
							final Response response = getRequest(token, country, vendorAccountId, endpoint, queryParams, null);

							response.then().log().ifValidationFails(LogDetail.ALL).statusCode(Integer.parseInt("200"));
							final String actualResponse = response.getBody().asString();
							JSONAssert.assertEquals(actualResponse, "[]", actualResponse, JSONCompareMode.NON_EXTENSIBLE);
						});
			});
		}
	}

	private void validateItemDeletion(final boolean shouldValidate, final String token, final String country, final String endpoint) {

		if (shouldValidate) {
			LOGGER.info(String.format("=== Validating the item deletion for %s ===", country));
			final Map<String, Object> queryParams = new HashMap<>();
			queryParams.put(VENDOR_ID_HEADER, VENDOR_ID);

			await().pollInterval(POLL_INTERVAL_IN_SECONDS, SECONDS).pollDelay(Duration.ZERO)
					.atMost(SECONDS_TO_AWAIT_ON_CLEAR_PROCESS, SECONDS).untilAsserted(() -> {
						final Response response = getRequest(token, country, null, endpoint, queryParams, null);

						response.then().log().ifValidationFails(LogDetail.ALL).statusCode(HttpStatus.SC_NOT_FOUND);
					});
		}
	}

	private List<String> extractValuesFromResponse(final Response response, final String root, final String key) {

		final JSONArray jsonArray = JsonPath.compile(root).read(response.getBody().asString());

		final List<String> values = new ArrayList<>();

		for (final Object value : jsonArray) {
			values.add(((Map<String, String>) value).get(key));
		}

		return values;
	}

	private LinkedHashMap<String, Object> generateDeletePayload(final List<String> values1, final List<String> values2,
			final String deletePayloadTemplate,
			final String key1, final String key2) {

		final LinkedHashMap<String, Object> payload = JsonPath.compile("$").read(deletePayloadTemplate);
		((List<String>) payload.get(key1)).addAll(values1);
		((List<String>) payload.get(key2)).addAll(values2);

		return payload;
	}
}