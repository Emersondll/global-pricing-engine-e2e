package configs;

public class EnvironmentConstants {

	public static final String ENVIRONMENT_UAT = "UAT";
	public static final String ENVIRONMENT_LOCAL = "LOCAL";

	public static final String DEAL_ENV_PARAMETER = "deal.env";
	public static final String CHARGE_ENV_PARAMETER = "charge.env";
	public static final String COMBO_ENV_PARAMETER = "combo.env";
	public static final String PRICE_ENV_PARAMETER = "price.env";
	public static final String PRICING_ENGINE_ENV_PARAMETER = "pricing.env";
	public static final String ACCOUNT_ENV_PARAMETER = "account.env";
	public static final String ITEM_ENV_PARAMETER = "item.env";
	public static final String ENFORCEMENT_ENV_PARAMETER = "enforcement.env";
	public static final String EMPTY_ENV_PARAMETER = "empties-service.env";
	public static final String PROMOTION_ENV_PARAMETER = "promotion.env";

	public static final String UAT_PRICE_API_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/api/price-service/v2";
	public static final String UAT_PRICE_API_ENDPOINT_V3 = "https://services-uat.bees-platform.dev/api/price-service/v3";
	public static final String UAT_PRICE_RELAY_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/api/price-relay/v2";
	public static final String UAT_PRICE_RELAY_ENDPOINT_V3 = "https://services-uat.bees-platform.dev/api/price-relay/v3";

	public static final String UAT_DEAL_API_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/api/deal-service/v2";
	public static final String UAT_DEAL_API_ENDPOINT_V3 = "https://services-uat.bees-platform.dev/api/deal-service/v3";
	public static final String UAT_DEAL_RELAY_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/api/deal-relay/v2";
	public static final String UAT_DEAL_RELAY_ENDPOINT_V3 = "https://services-uat.bees-platform.dev/api/deal-relay/v3";
	public static final String UAT_SORTED_DEAL_RELAY_ENDPOINT_V3 = "https://services-uat.bees-platform.dev/api/deal-relay/v3/deals";
	public static final String UAT_CHARGE_API_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/api/charge-service/v2";
	public static final String UAT_CHARGE_API_ENDPOINT_V3 = "https://services-uat.bees-platform.dev/api/charge-service/v3";
	public static final String UAT_CHARGE_RELAY_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/api/charge-relay/v2";
	public static final String UAT_CHARGE_RELAY_ENDPOINT_V3 = "https://services-uat.bees-platform.dev/api/charge-relay/v3";

	public static final String UAT_COMBO_API_ENDPOINT_V3 = "https://services-uat.bees-platform.dev/api/combos/v3/combos/accounts";
	public static final String UAT_COMBO_API_ENDPOINT_V4 = "https://services-uat.bees-platform.dev/api/combos/v4/contracts";
	public static final String UAT_COMBO_RELAY_ENDPOINT_V3 = "https://services-uat.bees-platform.dev/api/combo-relay/v3/combos/accounts";
	public static final String UAT_COMBO_RELAY_DDC_ENDPOINT_V3 = "https://services-uat.bees-platform.dev/api/combo-relay/v3/combos/delivery-centers";
	public static final String UAT_COMBO_SCORE_RELAY_ENDPOINT_V3 = "https://services-uat.bees-platform.dev/api/combo-relay/v3/combos/score";

	public static final String UAT_PRICING_ENGINE_CHARGE_API_ENDPOINT_V1 = "https://services-uat.bees-platform.dev/v1/pricing-engine/v1/charges";
	public static final String UAT_PRICING_ENGINE_CHARGE_API_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/v1/pricing-engine/v2/charges";
	public static final String UAT_PRICING_ENGINE_DEAL_API_ENDPOINT_V1 = "https://services-uat.bees-platform.dev/v1/pricing-engine/v1/deals";
	public static final String UAT_PRICING_ENGINE_DEAL_API_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/v1/pricing-engine/v2/deals";
	public static final String UAT_PRICING_ENGINE_ITEM_DISCOUNT_API_ENDPOINT_V1 = "https://services-uat.bees-platform.dev/v1/pricing-engine/v1/items/discounts";
	public static final String UAT_PRICING_ENGINE_ITEM_DISCOUNT_API_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/v1/pricing-engine/v2/items/discounts";
	public static final String UAT_PRICING_ENGINE_COMBO_API_ENDPOINT_V1 = "https://services-uat.bees-platform.dev/v1/pricing-engine/v1/combos";
	public static final String UAT_PRICING_ENGINE_COMBO_API_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/v1/pricing-engine/v2/combos";
	public static final String UAT_PRICING_ENGINE_API_ENDPOINT_V1 = "https://services-uat.bees-platform.dev/v1/pricing-engine/v1/simulation";
	public static final String UAT_PRICING_ENGINE_API_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/v1/pricing-engine/v2/simulation";
	public static final String UAT_PRICING_SIMULATION_DATA_API_ENDPOINT = "https://services-uat.bees-platform.dev/v1/pricing-engine/v2/simulation/data";
	public static final String UAT_PRICING_ENGINE_OFFERS_API_ENDPOINT_V1 = "https://services-uat.bees-platform.dev/v1/pricing-engine/v1/offers";
	public static final String UAT_PRICING_ENGINE_OFFERS_API_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/v1/pricing-engine/v2/offers";

	public static final String UAT_ACCOUNT_API_ENDPOINT_V1 = "https://services-uat.bees-platform.dev/v1/accounts";
	public static final String UAT_ACCOUNT_API_ENDPOINT_V2_CONTRACTS = "https://services-uat.bees-platform.dev/v1/accounts/v2/contracts";
	public static final String UAT_ACCOUNT_RELAY_ENDPOINT_V1 = "https://services-uat.bees-platform.dev/v1/account-relay";
	public static final String UAT_DELETE_ACCOUNT_RELAY_ENDPOINT_V1 = "https://services-uat.bees-platform.dev/v1/account-relay/{accountId}";
	public static final String UAT_ITEM_API_ENDPOINT_V1 = "https://services-uat.bees-platform.dev/api/items/items";
	public static final String UAT_ITEM_API_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/api/items/items/v2";
	public static final String UAT_ITEM_RELAY_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/api/item-relay/v2/items";
	public static final String UAT_DELETE_ITEM_RELAY_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/api/item-relay/v2/items/{vendorItemIds}";
	public static final String UAT_ENFORCEMENT_LIMITS_API_ENDPOINT_V3 = "https://services-uat.bees-platform.dev/api/enforcement-service/v3/limits";
	public static final String UAT_ENFORCEMENT_LIMITS_API_ENDPOINT_V4 = "https://services-uat.bees-platform.dev/api/enforcement-service/v4/limits";
	public static final String UAT_ENFORCEMENT_RELAY_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/api/enforcement-relay-service/v2";
	public static final String UAT_DELIVERY_WINDOW_API_ENDPOINT_V1 = "https://services-uat.bees-platform.dev/v1/delivery-windows";
	public static final String UAT_DELIVERY_WINDOW_RELAY_ENDPOINT_V1 = "https://services-uat.bees-platform.dev/v1/delivery-window-relay";
	public static final String UAT_EMPTY_API_ENDPOINT_V2 = "https://services-uat.bees-platform.dev/v1/empties-service/v2";
	public static final String UAT_EMPTY_RELAY_ENDPOINT_V1 = "https://services-uat.bees-platform.dev/v1/empties-relay-service/register/deliveryCenterIds";

	public static final String UAT_DATA_INGESTION_ENDPOINT_V1 = "https://services-uat.bees-platform.dev/api/v1/data-ingestion-relay-service/v1";
	public static final String UAT_PROMOTION_RELAY_ENDPOINT_V3 = "https://services-uat.bees-platform.dev/api/promotion-relay/v3/promotions";

	public static final String LOCAL_PRICE_API_ENDPOINT_V2 = "http://localhost:5003/v2";
	public static final String LOCAL_PRICE_API_ENDPOINT_V3 = "http://localhost:5003/v3";
	public static final String LOCAL_PRICE_RELAY_ENDPOINT_V2 = "http://localhost:5001/v2";
	public static final String LOCAL_PRICE_RELAY_ENDPOINT_V3 = "http://localhost:5001/v3";
	public static final String LOCAL_DEAL_API_ENDPOINT_V2 = "http://localhost:5006/v2";
	public static final String LOCAL_DEAL_API_ENDPOINT_V3 = "http://localhost:5006/v3";
	public static final String LOCAL_DEAL_RELAY_ENDPOINT_V2 = "http://localhost:5004/v2";
	public static final String LOCAL_DEAL_RELAY_ENDPOINT_V3 = "http://localhost:5004/v3";
	public static final String LOCAL_SORTED_DEAL_RELAY_ENDPOINT_V3 = "http://localhost:5004/v3/deals";
	public static final String LOCAL_COMBO_API_ENDPOINT_V3 = "http://localhost:5012/v3/combos/accounts";
	public static final String LOCAL_COMBO_RELAY_ENDPOINT_V3 = "http://localhost:5010/v3/combos/accounts";
	public static final String LOCAL_COMBO_RELAY_DDC_ENDPOINT_V3 = "http://localhost:5010/v3/combos/delivery-centers";
	public static final String LOCAL_COMBO_SCORE_RELAY_ENDPOINT_V3 = "http://localhost:5010/v3/combos/score";
	public static final String LOCAL_COMBO_API_ENDPOINT_V4 = "http://localhost:5012/v4/contracts";
	public static final String LOCAL_CHARGE_API_ENDPOINT_V2 = "http://localhost:5009/v2";
	public static final String LOCAL_CHARGE_API_ENDPOINT_V3 = "http://localhost:5009/v3";
	public static final String LOCAL_CHARGE_RELAY_ENDPOINT_V2 = "http://localhost:5007/v2";
	public static final String LOCAL_CHARGE_RELAY_ENDPOINT_V3 = "http://localhost:5022/v3";
	public static final String LOCAL_PRICING_ENGINE_CHARGE_API_ENDPOINT_V1 = "http://localhost:5000/v1/charges";
	public static final String LOCAL_PRICING_ENGINE_CHARGE_API_ENDPOINT_V2 = "http://localhost:5000/v2/charges";
	public static final String LOCAL_PRICING_ENGINE_DEAL_API_ENDPOINT_V1 = "http://localhost:5000/v1/deals";
	public static final String LOCAL_PRICING_ENGINE_DEAL_API_ENDPOINT_V2 = "http://localhost:5000/v2/deals";
	public static final String LOCAL_PRICING_ENGINE_ITEM_DISCOUNT_API_ENDPOINT_V1 = "http://localhost:5000/v1/items/discounts";
	public static final String LOCAL_PRICING_ENGINE_ITEM_DISCOUNT_API_ENDPOINT_V2 = "http://localhost:5000/v2/items/discounts";
	public static final String LOCAL_PRICING_ENGINE_COMBO_API_ENDPOINT_V1 = "http://localhost:5000/v1/combos";
	public static final String LOCAL_PRICING_ENGINE_COMBO_API_ENDPOINT_V2 = "http://localhost:5000/v2/combos";
	public static final String LOCAL_PRICING_ENGINE_API_ENDPOINT_V1 = "http://localhost:5000/v1/simulation";
	public static final String LOCAL_PRICING_ENGINE_API_ENDPOINT_V2 = "http://localhost:5000/v2/simulation";
	public static final String LOCAL_SIMULATION_DATA_API_ENDPOINT = "http://localhost:5000/v2/simulation/data";
	public static final String LOCAL_PRICING_ENGINE_OFFERS_API_ENDPOINT_V1 = "http://localhost:5000/v1/offers";
	public static final String LOCAL_PRICING_ENGINE_OFFERS_API_ENDPOINT_V2 = "http://localhost:5000/v2/offers";
	public static final String LOCAL_ACCOUNT_API_ENDPOINT_V1 = "http://localhost:5012";
	public static final String LOCAL_ACCOUNT_API_ENDPOINT_V2_CONTRACTS = "http://localhost:5012/v2/contracts";
	public static final String LOCAL_ACCOUNT_RELAY_ENDPOINT_V1 = "http://localhost:5010";
	public static final String LOCAL_DELETE_ACCOUNT_RELAY_ENDPOINT_V1 = "http://localhost:5010/{accountId}";
	public static final String LOCAL_ITEM_API_ENDPOINT_V1 = "http://localhost:5015/items";
	public static final String LOCAL_ITEM_API_ENDPOINT_V2 = "http://localhost:5015/items/items/v2";
	public static final String LOCAL_ITEM_RELAY_ENDPOINT_V2 = "http://localhost:5013/v2/items";
	public static final String LOCAL_DELETE_ITEM_RELAY_ENDPOINT_V2 = "http://localhost:5013/v2/items/{vendorItemIds}";
	public static final String LOCAL_ENFORCEMENT_LIMITS_API_ENDPOINT_V3 = "http://localhost:5014/v3/limits";
	public static final String LOCAL_ENFORCEMENT_LIMITS_API_ENDPOINT_V4 = "http://localhost:5014/v4/limits";
	public static final String LOCAL_ENFORCEMENT_RELAY_ENDPOINT_V2 = "http://localhost:5015/v2";
	public static final String LOCAL_DELIVERY_WINDOW_API_ENDPOINT_V1 = "http://localhost:5018";
	public static final String LOCAL_DELIVERY_WINDOW_RELAY_ENDPOINT_V1 = "http://localhost:5016";
	public static final String LOCAL_EMPTY_API_ENDPOINT_V2 = "http://localhost:5019/v2";
	public static final String LOCAL_EMPTY_RELAY_ENDPOINT_V1 = "http://localhost:5020/v1/register/deliveryCenterIds";
	public static final String LOCAL_PROMOTION_RELAY_ENDPOINT_V3 = "http://localhost:5021";
	public static final int SECONDS_TO_AWAIT_FOR_FINAL_VALIDATION = 120;
	public static final int SECONDS_TO_AWAIT = 300;
	public static final int SECONDS_TO_AWAIT_ON_CLEAR_PROCESS = 180;
	public static final int POLL_INTERVAL_IN_SECONDS = 10;
	public static final boolean EXECUTE_CLEAR_PROCESS = false;
}
