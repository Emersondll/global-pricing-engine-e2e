package helpers;

import static helpers.DateHelper.dateFormatter;
import static helpers.PlatformIdEncoderDecoderHelper.decodeContractIdToVendorAccountId;
import static helpers.PlatformIdEncoderDecoderHelper.decodeDeliveryCenterIdToVendorDeliveryCenterId;
import static helpers.TestConstants.ACCOUNT_ID_RESPONSE_PLACEHOLDER;
import static helpers.TestConstants.COMBO_ID_BY_VENDOR_PLACEHOLDER;
import static helpers.TestConstants.CURRENT_DATE_PLACEHOLDER;
import static helpers.TestConstants.DELIVERY_WINDOW_ID_BY_VENDOR_PLACEHOLDER;
import static helpers.TestConstants.DYNAMIC_ACCOUNT_ID_PLACEHOLDER;
import static helpers.TestConstants.DYNAMIC_COMBO_ACCOUNT_PLATFORM_ID_WITH_KEY_PLACEHOLDER;
import static helpers.TestConstants.DYNAMIC_COMBO_DELIVERY_CENTER_PLATFORM_ID_WITH_KEY_PLACEHOLDER;
import static helpers.TestConstants.DYNAMIC_CONTRACT_ID_PLACEHOLDER;
import static helpers.TestConstants.DYNAMIC_CONTRACT_ID_WITH_KEY_PLACEHOLDER;
import static helpers.TestConstants.DYNAMIC_DELIVERY_CENTER_ID_PLACEHOLDER;
import static helpers.TestConstants.DYNAMIC_DELIVERY_CENTER_ID_WITH_KEY_PLACEHOLDER;
import static helpers.TestConstants.DYNAMIC_ENFORCEMENT_PLATFORM_ID_WITH_KEY_PLACEHOLDER;
import static helpers.TestConstants.DYNAMIC_PRICE_LIST_ID_PLACEHOLDER;
import static helpers.TestConstants.DYNAMIC_PRICE_LIST_ID_WITH_KEY_PLACEHOLDER;
import static helpers.TestConstants.DYNAMIC_TAX_ID_PLACEHOLDER;
import static helpers.TestConstants.DYNAMIC_TAX_ID_WITH_KEY_PLACEHOLDER;
import static helpers.TestConstants.DYNAMIC_TIMEZONE;
import static helpers.TestConstants.DYNAMIC_VENDOR_ACCOUNT_ID_WITH_KEY_PLACEHOLDER;
import static helpers.TestConstants.DYNAMIC_VENDOR_DELIVERY_CENTER_ID_PLACEHOLDER;
import static helpers.TestConstants.DYNAMIC_VENDOR_DELIVERY_CENTER_ID_WITH_KEY_PLACEHOLDER;
import static helpers.TestConstants.DYNAMIC_VENDOR_ID_PLACEHOLDER;
import static helpers.TestConstants.FREE_GOODS_HASHCODE_PLACEHOLDER;
import static helpers.TestConstants.FREE_GOODS_V2_HASHCODE_PLACEHOLDER;
import static helpers.TestConstants.ITEM_ID_BY_VENDOR_PLACEHOLDER;
import static helpers.TestConstants.TIMEZONE_HEADER;
import static helpers.TestConstants.TIMEZONE_PLACEHOLDER;
import static helpers.TestConstants.VALID_FROM_DATE_FORMAT;
import static helpers.TestConstants.VENDOR_ID_BY_KEY_PLACEHOLDER;
import static helpers.TestConstants.VENDOR_ID_HEADER;
import static helpers.TestConstants.VENDOR_ID_WITH_KEY_PLACEHOLDER;
import static java.util.Optional.ofNullable;
import static org.apache.commons.lang3.StringUtils.EMPTY;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import org.apache.commons.codec.digest.DigestUtils;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.json.JsonMapper;
import com.google.common.io.Resources;
import com.jayway.jsonpath.JsonPath;

import context.TestContext;
import io.restassured.response.ResponseBodyData;
import io.restassured.response.ResponseOptions;

public class JsonLoader {

	private static final Pattern FREE_GOODS_HASHCODE_PLACEHOLDER_PATTERN = Pattern.compile(FREE_GOODS_HASHCODE_PLACEHOLDER);
	private static final Pattern FREE_GOODS_V2_HASHCODE_PLACEHOLDER_PATTERN = Pattern.compile(FREE_GOODS_V2_HASHCODE_PLACEHOLDER);
	private static final Pattern ACCOUNT_ID_RESPONSE_PLACEHOLDER_PATTERN = Pattern.compile(ACCOUNT_ID_RESPONSE_PLACEHOLDER);

	private static final ObjectMapper objectMapper = JsonMapper.builder().build();

	private JsonLoader() {

	}

	private static String buildResourceLocation(final String folder, final String subPath, final String fileName) {

		return String.format("payloads/%s/%s/%s.json", folder, subPath, fileName);
	}

	public static Object getRequestDataFileContent(final TestContext testContext, final String fileName) throws IOException {

		final URL url = Resources.getResource(buildResourceLocation(testContext.getFolder(), "inputs", fileName));
		String fileContent = Resources.toString(url, StandardCharsets.UTF_8);

		fileContent = applyPlaceHolders(fileContent, testContext);

		return JsonPath.compile("$").read(fileContent);
	}

	public static String getResponseDataFileContentAsString(final String folder, final String fileName, final TestContext testContext)
			throws IOException {

		return applyPlaceHolders(
				Files.readString(new File("src/test/resources/payloads/" + folder + "/outputs/" + fileName + ".json").toPath()),
				testContext);
	}

	public static String getRequestDataFileContentAsString(final String folder, final String fileName) throws IOException {

		return Files.readString(new File("src/test/resources/payloads/" + folder + "/inputs/" + fileName + ".json").toPath());
	}

	public static String applyPlaceHolders(String fileContent, final TestContext testContext) {

		if (ofNullable(testContext).map(TestContext::getRequestHeaders).map(map -> map.get(TIMEZONE_HEADER)).isPresent()) {
			final var timezone = testContext.getRequestHeaders().get(TIMEZONE_HEADER).toString();
			fileContent = fileContent.replace(TIMEZONE_PLACEHOLDER, timezone);
			final ZoneId zoneid;
			System.out.println(testContext.getFolder());
			if (testContext.getFolder().contains("combo-service") //For combos/v3
					|| testContext.getFolder().contains("account-service") // For Account/v1
					|| testContext.getFolder().contains("item-service") //For items/v1 and items/v2
			) {
				zoneid = ZoneId.of("UTC");
				System.out.println("\n" + "UTC: " + zoneid + "\n");
			} else {
				zoneid = ZoneId.of(timezone);
				System.out.println("\n" + "zoneid: " + zoneid + "\n");
			}
			final ZonedDateTime zoneddatetime = ZonedDateTime.now(zoneid);
			System.out.println("\n" + zoneddatetime + "\n");

			fileContent = fileContent.replace(CURRENT_DATE_PLACEHOLDER,
					dateFormatter(zoneddatetime, VALID_FROM_DATE_FORMAT));
		} else {
			fileContent = fileContent.replace(CURRENT_DATE_PLACEHOLDER, dateFormatter(new Date(), VALID_FROM_DATE_FORMAT));
		}
		if (ofNullable(testContext).map(TestContext::getTimeZone).isPresent()) {
			fileContent = fileContent.replace(DYNAMIC_TIMEZONE, testContext.getTimeZone());
		}
		if (ofNullable(testContext).map(TestContext::getDynamicVendorAccountId).isPresent()) {
			fileContent = fileContent.replace(DYNAMIC_ACCOUNT_ID_PLACEHOLDER, testContext.getDynamicVendorAccountId());
		}
		if (ofNullable(testContext).map(TestContext::getDynamicPriceListId).isPresent()) {
			fileContent = fileContent.replace(DYNAMIC_PRICE_LIST_ID_PLACEHOLDER, testContext.getDynamicPriceListId());
		}
		if (ofNullable(testContext).map(TestContext::getDynamicDeliveryCenterPlatformId).isPresent()) {
			fileContent = fileContent.replace(DYNAMIC_DELIVERY_CENTER_ID_PLACEHOLDER, testContext.getDynamicDeliveryCenterPlatformId());
		}
		if (ofNullable(testContext).map(TestContext::getDynamicVendorDeliveryCenterId).isPresent()) {
			fileContent = fileContent.replace(DYNAMIC_VENDOR_DELIVERY_CENTER_ID_PLACEHOLDER,
					testContext.getDynamicVendorDeliveryCenterId());
		}
		if (ofNullable(testContext).map(TestContext::getDynamicContractId).isPresent()) {
			fileContent = fileContent.replace(DYNAMIC_CONTRACT_ID_PLACEHOLDER, testContext.getDynamicContractId());
		}
		if (ofNullable(testContext).map(TestContext::getRequestHeaders).isPresent()) {
			fileContent = fileContent.replace(DYNAMIC_VENDOR_ID_PLACEHOLDER,
					testContext.getRequestHeaders().getOrDefault(VENDOR_ID_HEADER, EMPTY).toString());
		}
		if (ofNullable(testContext).map(TestContext::getTaxId).isPresent()) {
			fileContent = fileContent.replace(DYNAMIC_TAX_ID_PLACEHOLDER, testContext.getTaxId());
		}

		fileContent = applyFreeGoodsHashcodePlaceHolder(fileContent, testContext);

		fileContent = applyIgnoreStringPlaceHolder(fileContent, testContext);

		fileContent = applyDynamicAccountIdWithKeyPlaceHolder(fileContent, testContext);

		fileContent = applyDynamicContractIdWithKeyPlaceHolder(fileContent, testContext);

		fileContent = applyDynamicPriceListIdWithKeyPlaceHolder(fileContent, testContext);

		fileContent = applyDynamicTaxIdWithKeyPlaceHolder(fileContent, testContext);

		fileContent = applyItemIdWithVendorKeyPlaceHolder(fileContent, testContext);

		fileContent = applyDeliveryWindowIdWithVendorKeyPlaceHolder(fileContent, testContext);

		fileContent = applyComboIdWithVendorKeyPlaceHolder(fileContent, testContext);

		fileContent = applyDynamicVendorDeliveryCenterIdWithKeyPlaceHolder(fileContent, testContext);

		fileContent = applyDynamicDeliveryCenterIdWithKeyPlaceHolder(fileContent, testContext);

		fileContent = applyDynamicVendorIdWithKeyPlaceHolder(fileContent, testContext);

		fileContent = applyVendorIdByKeyPlaceHolder(fileContent, testContext);

		fileContent = applyDynamicEnforcementPlatformIdWithKeyPlaceHolder(fileContent, testContext);

		fileContent = applyDynamicComboAccountPlatformIdWithKeyPlaceHolder(fileContent, testContext);

		fileContent = applyDynamicComboDeliveryCenterPlatformIdWithKeyPlaceHolder(fileContent, testContext);

		fileContent = applyDynamicTimeZonePlaceHolder(fileContent, testContext);

		return fileContent;
	}

	private static String applyIgnoreStringPlaceHolder(final String fileContent, final TestContext testContext) {

		final String actualResponse = ofNullable(testContext.getResponse()).map(ResponseOptions::getBody).map(ResponseBodyData::asString)
				.orElse(null);
		if (actualResponse == null) {
			return fileContent;
		}

		String result = fileContent;
		try {
			Object content = JsonPath.compile("$").read(actualResponse);
			final List<String> accountIdsInResponse = new ArrayList<>();
			if (content instanceof List) {
				final List<Object> listContent = convertToList(content);
				for (final Object account : listContent) {
					if (account instanceof Map) {
						final Map<Object, Object> accountMap = convertToMap(account);
						if (accountMap.containsKey("accountId")) {
							accountIdsInResponse.add((String) accountMap.get("accountId"));
						}
					}
				}
			}

			content = JsonPath.compile("$").read(fileContent);
			final List<String> accountIdsReplaced = new ArrayList<>();
			if (content instanceof List) {
				final List<Object> listContent = convertToList(content);
				for (final Object account : listContent) {
					if (account instanceof Map) {
						final Map<Object, Object> accountMap = convertToMap(account);
						if (accountMap.containsKey("accountId")) {
							final String accountId = (String) accountMap.get("accountId");

							final Matcher matcher = ACCOUNT_ID_RESPONSE_PLACEHOLDER_PATTERN.matcher(accountId);
							if (matcher.find()) {
								final String index = matcher.group(1);
								accountIdsReplaced.add(accountIdsInResponse.get(Integer.parseInt(index)));
							}
						}
					}
				}
			}

			for (final String accountIdReplaced : accountIdsReplaced) {
				result = result.replaceFirst(ACCOUNT_ID_RESPONSE_PLACEHOLDER, accountIdReplaced);
			}
		} catch (final Exception e) {
			e.printStackTrace();
			return fileContent;
		}

		return result;
	}

	private static String applyFreeGoodsHashcodePlaceHolder(final String fileContent, final TestContext testContext) {

		String result = fileContent;
		try {
			final List<String> hashcodes = new ArrayList<>();

			final Object content = JsonPath.compile("$").read(fileContent);
			if (content instanceof Map) {
				final Map<Object, Object> mapContent = convertToMap(content);

				if (mapContent.containsKey("simulations")) {
					final List<Object> simulations = convertToList(mapContent.get("simulations"));
					for (final Object simulation : simulations) {
						extractedFreegoods(testContext, hashcodes, convertToMap(simulation), true);
					}
				} else {
					extractedFreegoods(testContext, hashcodes, mapContent, false);
				}
			}

			for (final String hashcode : hashcodes) {
				result = result.replaceFirst(FREE_GOODS_HASHCODE_PLACEHOLDER, hashcode);
				result = result.replaceFirst(FREE_GOODS_V2_HASHCODE_PLACEHOLDER, hashcode);
			}
		} catch (final Exception e) {
			e.printStackTrace();
			return fileContent;
		}

		return result;
	}

	private static void extractedFreegoods(final TestContext testContext, final List<String> hashcodes,
			final Map<Object, Object> mapContent, final Boolean isV2) {

		if (mapContent.containsKey("freeGoods")) {
			final Object freeGoodsContent = mapContent.get("freeGoods");
			if (freeGoodsContent instanceof List) {
				final List<Object> freeGoods = convertToList(freeGoodsContent);
				for (final Object freeGood : freeGoods) {
					if (freeGood instanceof Map) {
						final Map<Object, Object> freeGoodMap = convertToMap(freeGood);
						if (isV2) {
							ofNullable(generateHashV2(freeGoodMap, testContext)).ifPresent(hashcodes::add);
						} else {
							ofNullable(generateHash(freeGoodMap, testContext.getDynamicVendorAccountId())).ifPresent(hashcodes::add);
						}
					}
				}
			}
		}
	}

	private static String generateHash(final Map<Object, Object> freeGoodMap, final String dynamicAccountId) {

		final Map<Object, Object> deal = convertToMap(freeGoodMap.get("deal"));
		final String vendorDealId = (String) deal.get("vendorDealId");
		final String hashcode = (String) freeGoodMap.get("hashcode");
		final Matcher matcher = FREE_GOODS_HASHCODE_PLACEHOLDER_PATTERN.matcher(hashcode);

		if (!matcher.find()) {
			return null;
		}

		final String originalQuantity = matcher.group(1);
		final List<Object> freeGoodItems = convertToList(freeGoodMap.get("vendorItemIds"));

		final String vendorItemsId = freeGoodItems.stream()
				.map(item -> (new StringBuilder()).append((convertToMap(item)).get("vendorItemId"))
						.append((convertToMap(item)).get("measureUnit"))).collect(Collectors.joining());
		final String concat = vendorDealId + dynamicAccountId + originalQuantity + vendorItemsId;

		return DigestUtils.md5Hex(concat);
	}

	private static String generateHashV2(final Map<Object, Object> freeGoodMap, final TestContext testContext) {

		final Map<Object, Object> deal = convertToMap(freeGoodMap.get("deal"));
		final String vendorPromotionId = (String) deal.get("vendorDealId");
		final String hashcode = (String) freeGoodMap.get("hashCode");
		final Matcher matcher = FREE_GOODS_V2_HASHCODE_PLACEHOLDER_PATTERN.matcher(hashcode);

		if (!matcher.find()) {
			return null;
		}

		final String type = matcher.group(1);
		final String key = matcher.group(2);
		final String originalQuantity = matcher.group(3);
		String platformId = "";

		if (type.equals("CONTRACT")) {
			final String contractId = testContext.getDynamicContractIdByKey(Integer.parseInt(key));
			platformId = decodeContractIdToVendorAccountId(contractId);
		} else if (type.equals("DELIVERY_CENTER")) {
			final String deliveryCenterId = testContext.getDynamicDeliveryCenterIdByKey(Integer.parseInt(key));
			platformId = decodeDeliveryCenterIdToVendorDeliveryCenterId(deliveryCenterId);
		}

		final List<Object> freeGoodItems = convertToList(freeGoodMap.get("items"));

		final String vendorItemsId = freeGoodItems.stream()
				.map(item -> (new StringBuilder()).append((convertToMap(item)).get("vendorItemId"))
						.append((convertToMap(item)).get("measureUnit"))).collect(Collectors.joining());
		final String concat = vendorPromotionId + platformId + originalQuantity + vendorItemsId;

		return DigestUtils.md5Hex(concat);
	}

	private static String applyDynamicAccountIdWithKeyPlaceHolder(final String fileContent, final TestContext testContext) {

		String newfileContent = fileContent;

		final Pattern pattern = Pattern.compile(DYNAMIC_VENDOR_ACCOUNT_ID_WITH_KEY_PLACEHOLDER);
		final Matcher matcher = pattern.matcher(newfileContent);

		while (matcher.find()) {
			final String key = matcher.group(1);
			final String valueToReplace = matcher.group(0);
			final String dynamicVendorAccountIdByKey = testContext.getDynamicVendorAccountIdByKey(Integer.parseInt(key));

			newfileContent = newfileContent.replace(valueToReplace, dynamicVendorAccountIdByKey);
		}

		return newfileContent;
	}

	private static String applyDynamicContractIdWithKeyPlaceHolder(final String fileContent, final TestContext testContext) {

		String newfileContent = fileContent;

		final Pattern pattern = Pattern.compile(DYNAMIC_CONTRACT_ID_WITH_KEY_PLACEHOLDER);
		final Matcher matcher = pattern.matcher(newfileContent);

		while (matcher.find()) {
			final String key = matcher.group(1);
			final String valueToReplace = matcher.group(0);
			final String contractId = testContext.getDynamicContractIdByKey(Integer.parseInt(key));

			newfileContent = newfileContent.replace(valueToReplace, contractId);
		}

		return newfileContent;
	}

	private static String applyDynamicPriceListIdWithKeyPlaceHolder(final String fileContent, final TestContext testContext) {

		String newfileContent = fileContent;

		final Pattern pattern = Pattern.compile(DYNAMIC_PRICE_LIST_ID_WITH_KEY_PLACEHOLDER);
		final Matcher matcher = pattern.matcher(newfileContent);

		while (matcher.find()) {
			final String key = matcher.group(1);
			final String valueToReplace = matcher.group(0);
			final String priceListId = testContext.getDynamicPriceListIdByKey(Integer.parseInt(key));

			newfileContent = newfileContent.replace(valueToReplace, priceListId);
		}

		return newfileContent;
	}

	private static String applyDynamicTaxIdWithKeyPlaceHolder(final String fileContent, final TestContext testContext) {

		String newFileContent = fileContent;

		final Pattern pattern = Pattern.compile(DYNAMIC_TAX_ID_WITH_KEY_PLACEHOLDER);
		final Matcher matcher = pattern.matcher(newFileContent);

		while (matcher.find()) {
			final String key = matcher.group(1);
			final String valueToReplace = matcher.group(0);
			final String taxId = testContext.getDynamicTaxIdByKey(Integer.parseInt(key));

			newFileContent = newFileContent.replace(valueToReplace, taxId);
		}

		return newFileContent;
	}

	private static String applyDynamicVendorDeliveryCenterIdWithKeyPlaceHolder(final String fileContent, final TestContext testContext) {

		String newfileContent = fileContent;

		final Pattern pattern = Pattern.compile(DYNAMIC_VENDOR_DELIVERY_CENTER_ID_WITH_KEY_PLACEHOLDER);
		final Matcher matcher = pattern.matcher(newfileContent);

		while (matcher.find()) {
			final String key = matcher.group(1);
			final String valueToReplace = matcher.group(0);
			final String dynamicDeliveryCenterIdByKey = testContext.getDynamicDeliveryCenterIdByKey(Integer.parseInt(key));

			final String vendorDeliveryCenterId = decodeDeliveryCenterIdToVendorDeliveryCenterId(dynamicDeliveryCenterIdByKey);

			newfileContent = newfileContent.replace(valueToReplace, vendorDeliveryCenterId);
		}

		return newfileContent;
	}

	private static String applyDynamicDeliveryCenterIdWithKeyPlaceHolder(final String fileContent, final TestContext testContext) {

		String newfileContent = fileContent;

		final Pattern pattern = Pattern.compile(DYNAMIC_DELIVERY_CENTER_ID_WITH_KEY_PLACEHOLDER);
		final Matcher matcher = pattern.matcher(newfileContent);

		while (matcher.find()) {
			final String key = matcher.group(1);
			final String valueToReplace = matcher.group(0);
			final String dynamicDeliveryCenterIdByKey = testContext.getDynamicDeliveryCenterIdByKey(Integer.parseInt(key));

			newfileContent = newfileContent.replace(valueToReplace, dynamicDeliveryCenterIdByKey);
		}

		return newfileContent;
	}

	private static String applyDynamicVendorIdWithKeyPlaceHolder(final String fileContent, final TestContext testContext) {

		String newfileContent = fileContent;

		final Pattern pattern = Pattern.compile(VENDOR_ID_WITH_KEY_PLACEHOLDER);
		final Matcher matcher = pattern.matcher(newfileContent);

		while (matcher.find()) {
			final String key = matcher.group(1);
			final String valueToReplace = matcher.group(0);
			final String dynamicContractIdByKey = Optional.ofNullable(testContext.getDynamicDeliveryCenterIdByKey(Integer.parseInt(key)))
					.orElse(testContext.getDynamicContractIdByKey(Integer.parseInt(key)));

			final String vendorId = PlatformIdEncoderDecoderHelper.getVendorIdFromDeliveryCenterId(dynamicContractIdByKey);

			newfileContent = newfileContent.replace(valueToReplace, vendorId);
		}

		return newfileContent;
	}

	private static String applyVendorIdByKeyPlaceHolder(final String fileContent, final TestContext testContext) {

		String newFileContent = fileContent;

		final Pattern pattern = Pattern.compile(VENDOR_ID_BY_KEY_PLACEHOLDER);
		final Matcher matcher = pattern.matcher(newFileContent);

		while (matcher.find()) {
			final String key = matcher.group(1);
			final String valueToReplace = matcher.group(0);
			final String vendorId = testContext.getVendorIdByKey(key);
			newFileContent = newFileContent.replace(valueToReplace, vendorId);
		}

		return newFileContent;
	}

	private static String applyDynamicEnforcementPlatformIdWithKeyPlaceHolder(final String fileContent, final TestContext testContext) {

		String newfileContent = fileContent;

		final Pattern pattern = Pattern.compile(DYNAMIC_ENFORCEMENT_PLATFORM_ID_WITH_KEY_PLACEHOLDER);
		final Matcher matcher = pattern.matcher(newfileContent);

		while (matcher.find()) {
			final String key = matcher.group(1);
			final String valueToReplace = matcher.group(0);
			final String dynamicEnforcementPlatformIdByKey = testContext.getDynamicEnforcementPlatformIdByKey(Integer.parseInt(key));
			newfileContent = newfileContent.replace(valueToReplace, dynamicEnforcementPlatformIdByKey);
		}

		return newfileContent;
	}

	private static String applyDynamicTimeZonePlaceHolder(final String fileContent, final TestContext testContext) {

		String newfileContent = fileContent;

		final Pattern pattern = Pattern.compile(DYNAMIC_TIMEZONE);
		final Matcher matcher = pattern.matcher(newfileContent);

		while (matcher.find()) {
			final String valueToReplace = matcher.group(0);
			final String timeZone = testContext.getTimeZone();
			newfileContent = newfileContent.replace(valueToReplace, timeZone);
		}
		return newfileContent;
	}

	private static String applyDynamicComboAccountPlatformIdWithKeyPlaceHolder(final String fileContent, final TestContext testContext) {

		String newfileContent = fileContent;

		final Pattern pattern = Pattern.compile(DYNAMIC_COMBO_ACCOUNT_PLATFORM_ID_WITH_KEY_PLACEHOLDER);
		final Matcher matcher = pattern.matcher(newfileContent);

		while (matcher.find()) {
			final String key = matcher.group(1);
			final String valueToReplace = matcher.group(0);
			final String dynamicComboAccountPlatformIdByKey = testContext.getDynamicComboAccountPlatformIdByKey(Integer.parseInt(key));
			newfileContent = newfileContent.replace(valueToReplace, dynamicComboAccountPlatformIdByKey);
		}

		return newfileContent;
	}

	private static String applyDynamicComboDeliveryCenterPlatformIdWithKeyPlaceHolder(final String fileContent,
			final TestContext testContext) {

		String newfileContent = fileContent;

		final Pattern pattern = Pattern.compile(DYNAMIC_COMBO_DELIVERY_CENTER_PLATFORM_ID_WITH_KEY_PLACEHOLDER);
		final Matcher matcher = pattern.matcher(newfileContent);

		while (matcher.find()) {
			final String key = matcher.group(1);
			final String valueToReplace = matcher.group(0);
			final String dynamicComboDeliveryCenterPlatformIdByKey = testContext.getDynamicComboDeliveryCenterPlatformIdByKey(
					Integer.parseInt(key));
			newfileContent = newfileContent.replace(valueToReplace, dynamicComboDeliveryCenterPlatformIdByKey);
		}

		return newfileContent;
	}

	private static Map<Object, Object> convertToMap(final Object content) {

		return objectMapper.convertValue(content, new TypeReference<>() {
		});
	}

	private static List<Object> convertToList(final Object content) {

		return objectMapper.convertValue(content, new TypeReference<>() {
		});
	}

	private static String applyItemIdWithVendorKeyPlaceHolder(final String fileContent, final TestContext testContext) {

		String newFileContent = fileContent;

		final Pattern pattern = Pattern.compile(ITEM_ID_BY_VENDOR_PLACEHOLDER);
		final Matcher matcher = pattern.matcher(newFileContent);

		while (matcher.find()) {
			final String vendorKey = matcher.group(2);
			final String vendorId = testContext.getVendorIdByKey(vendorKey);
			final String vendorItemId = matcher.group(1);
			final String valueToReplace = matcher.group(0);
			final String itemId = PlatformIdEncoderDecoderHelper.encodeItemId(vendorId, vendorItemId);

			newFileContent = newFileContent.replace(valueToReplace, itemId);
		}
		return newFileContent;
	}

	private static String applyDeliveryWindowIdWithVendorKeyPlaceHolder(final String fileContent, final TestContext testContext) {

		String newFileContent = fileContent;

		final Pattern pattern = Pattern.compile(DELIVERY_WINDOW_ID_BY_VENDOR_PLACEHOLDER);
		final Matcher matcher = pattern.matcher(newFileContent);

		while (matcher.find()) {
			final String vendorKey = matcher.group(2);
			final String vendorId = testContext.getVendorIdByKey(vendorKey);
			final String vendorDeliveryWindowId = matcher.group(1);
			final String valueToReplace = matcher.group(0);
			final String deliveryWindowId = PlatformIdEncoderDecoderHelper.encodeDeliveryWindowId(vendorId, vendorDeliveryWindowId);

			newFileContent = newFileContent.replace(valueToReplace, deliveryWindowId);
		}
		return newFileContent;
	}

	private static String applyComboIdWithVendorKeyPlaceHolder(final String fileContent, final TestContext testContext) {

		String newFileContent = fileContent;

		final Pattern pattern = Pattern.compile(COMBO_ID_BY_VENDOR_PLACEHOLDER);
		final Matcher matcher = pattern.matcher(newFileContent);

		while (matcher.find()) {
			final String vendorKey = matcher.group(2);
			final String vendorId = testContext.getVendorIdByKey(vendorKey);
			final String vendorComboId = matcher.group(1);
			final String valueToReplace = matcher.group(0);
			final String comboId = PlatformIdEncoderDecoderHelper.encodeComboId(vendorId, vendorComboId);

			newFileContent = newFileContent.replace(valueToReplace, comboId);
		}
		return newFileContent;
	}

}