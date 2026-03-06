package helpers;

public class TestConstants {

	public static final String AUTHORIZATION_HEADER = "Authorization";
	public static final String CONTENT_TYPE_HEADER = "Content-Type";
	public static final String TIMESTAMP_HEADER = "x-timestamp";
	public static final String REQUEST_TRACE_ID_HEADER = "requestTraceId";
	public static final String COUNTRY_HEADER = "country";
	public static final String TIMEZONE_HEADER = "timezone";
	public static final String DELIVERY_DATE_HEADER = "deliveryDate";
	public static final String APPLICATION_JSON = "application/json";
	public static final String TRACE_ID = "e2e-pricing-engine-%s";
	public static final String CLIENT_ID_PARAMETER = "client_id";
	public static final String CLIENT_SECRET_PARAMETER = "client_secret";
	public static final String SCOPE_PARAMETER = "scope";
	public static final String ACCESS_TOKEN_REGEX = "\"access_token\": \"(.*?)\"";
	public static final String GRANT_TYPE_PARAMETER = "grant_type";
	public static final String VENDOR_ID_HEADER = "vendorId";
	public static final String VENDOR_ACCOUNT_ID_HEADER = "vendorAccountId";
	public static final String VENDOR_ACCOUNT_ID_PARAMETER = "vendorAccountId";
	public static final String VENDOR_ID = "25ead8c9-a15b-4394-b725-d62e18a2ea77";
	public static final String DYNAMIC_TIMEZONE = "## WILL BE REPLACED BY TIME ZONE BY COUNTRY ##";
	public static final String CURRENT_DATE_PLACEHOLDER = "## WILL BE REPLACED BY CURRENT DATE ##";
	public static final String TIMEZONE_PLACEHOLDER = "## WILL BE REPLACED BY HEADER TIMEZONE ##";
	public static final String DYNAMIC_ACCOUNT_ID_PLACEHOLDER = "## WILL BE REPLACED BY DYNAMIC ACCOUNT_ID ##";
	public static final String DYNAMIC_VENDOR_DELIVERY_CENTER_ID_PLACEHOLDER = "## WILL BE REPLACED BY DYNAMIC VENDOR DELIVERY_CENTER_ID ##";
	public static final String DYNAMIC_CONTRACT_ID_PLACEHOLDER = "## WILL BE REPLACED BY DYNAMIC CONTRACT_ID ##";
	public static final String DYNAMIC_DELIVERY_CENTER_ID_PLACEHOLDER = "## WILL BE REPLACED BY DYNAMIC DELIVERY_CENTER_ID ##";
	public static final String DYNAMIC_PRICE_LIST_ID_PLACEHOLDER = "## WILL BE REPLACED BY DYNAMIC PRICE_LIST_ID ##";
	public static final String DYNAMIC_VENDOR_ACCOUNT_ID_WITH_KEY_PLACEHOLDER = "## WILL BE REPLACED BY DYNAMIC ACCOUNT_ID WITH KEY (\\d+) ##";
	public static final String DYNAMIC_VENDOR_ID_PLACEHOLDER = "## WILL BE REPLACED BY DYNAMIC VENDOR_ID ##";
	public static final String VENDOR_ID_BY_KEY_PLACEHOLDER = "## WILL BE REPLACED BY VENDOR_ID WITH KEY '([^']+)' ##";
	public static final String ITEM_ID_BY_VENDOR_PLACEHOLDER = "## WILL BE REPLACED BY ITEM_ID WITH VENDOR_ITEM_ID '([^']+)' AND VENDOR KEY '([^']+)' ##";
	public static final String DELIVERY_WINDOW_ID_BY_VENDOR_PLACEHOLDER = "## WILL BE REPLACED BY DELIVERY_WINDOW_ID WITH VENDOR_DELIVERY_WINDOW_ID '([^']+)' AND VENDOR KEY '([^']+)' ##";
	public static final String COMBO_ID_BY_VENDOR_PLACEHOLDER = "## WILL BE REPLACED BY COMBO_ID WITH VENDOR_COMBO_ID '([^']+)' AND VENDOR KEY '([^']+)' ##";
	public static final String DYNAMIC_CONTRACT_ID_WITH_KEY_PLACEHOLDER = "## WILL BE REPLACED BY DYNAMIC CONTRACT_ID WITH KEY (\\d+) ##";
	public static final String DYNAMIC_VENDOR_DELIVERY_CENTER_ID_WITH_KEY_PLACEHOLDER = "## WILL BE REPLACED BY DYNAMIC DELIVERY_CENTER_ID WITH KEY (\\d+) ##";
	public static final String DYNAMIC_DELIVERY_CENTER_ID_WITH_KEY_PLACEHOLDER = "## WILL BE REPLACED BY DYNAMIC DELIVERY_CENTER_ID HASH WITH KEY (\\d+) ##";
	public static final String DYNAMIC_PRICE_LIST_ID_WITH_KEY_PLACEHOLDER = "## WILL BE REPLACED BY DYNAMIC PRICE_LIST_ID WITH KEY (\\d+) ##";
	public static final String DYNAMIC_TAX_ID_WITH_KEY_PLACEHOLDER = "## WILL BE REPLACED BY DYNAMIC TAX_ID WITH KEY (\\d+) ##";
	public static final String DYNAMIC_ENFORCEMENT_PLATFORM_ID_WITH_KEY_PLACEHOLDER = "## WILL BE REPLACED BY DYNAMIC ENFORCEMENT_PLATFORM_ID WITH KEY (\\d+) ##";
	public static final String DYNAMIC_COMBO_ACCOUNT_PLATFORM_ID_WITH_KEY_PLACEHOLDER = "## WILL BE REPLACED BY DYNAMIC COMBO_ACCOUNT_PLATFORM_ID WITH KEY (\\d+) ##";
	public static final String DYNAMIC_COMBO_DELIVERY_CENTER_PLATFORM_ID_WITH_KEY_PLACEHOLDER = "## WILL BE REPLACED BY DYNAMIC COMBO_DELIVERY_CENTER_PLATFORM_ID WITH KEY (\\d+) ##";
	public static final String DYNAMIC_TAX_ID_PLACEHOLDER = "## WILL BE REPLACED BY DYNAMIC TAX_ID ##";
	public static final String VENDOR_ID_WITH_KEY_PLACEHOLDER = "## WILL BE REPLACED BY VENDOR_ID WITH KEY (\\d+) ##";
	public static final String FREE_GOODS_HASHCODE_PLACEHOLDER = "## WILL BE REPLACED BY FREE GOODS HASH CODE. DEAL ORIGINAL QUANTITY (\\d+) ##";
	public static final String FREE_GOODS_V2_HASHCODE_PLACEHOLDER = "## WILL BE REPLACED BY FREE GOODS HASH CODE. (CONTRACT|DELIVERY_CENTER) WITH KEY (\\d+). DEAL ORIGINAL QUANTITY (\\d+) ##";
	public static final String ACCOUNT_ID_RESPONSE_PLACEHOLDER = "## WILL BE REPLACED BY ACCOUNT_ID IN RESPONSE AT INDEX (\\d+) ##";
	public static final String VALID_FROM_DATE_FORMAT = "yyyy-MM-dd";
	public static final String PRICE_LIST_ID_HEADER = "priceListId";
	public static final String ACCOUNT_ID_PATH = "accountId";
	public static final String VENDOR_ITEM_IDS_PATH = "vendorItemIds";

	public static final String DELIVERY_CENTER_IDS_PATH = "deliveryCenterIds";

	private TestConstants() {

	}
}
