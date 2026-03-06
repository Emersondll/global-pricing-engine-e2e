package steps.definitions;

import static configs.EnvironmentConstants.*;
import static helpers.TestConstants.APPLICATION_JSON;
import static helpers.TestConstants.CONTENT_TYPE_HEADER;

import java.util.Map;

import configs.EnvironmentConfig;
import helpers.BaseStepDefinitions;
import io.cucumber.java.en.When;
import io.restassured.http.Method;

public class ApiSteps extends BaseStepDefinitions {

	@When("^I get prices through v2 endpoint$")
	public void iGetPricesThroughV2Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext()
				.setRequestEndpoint(EnvironmentConfig.runPriceServiceLocally() ? LOCAL_PRICE_API_ENDPOINT_V2 : UAT_PRICE_API_ENDPOINT_V2);
	}

	@When("^I get deals through v2 endpoint$")
	public void iGetDealsThroughV2Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext()
				.setRequestEndpoint(EnvironmentConfig.runDealServiceLocally() ? LOCAL_DEAL_API_ENDPOINT_V2 : UAT_DEAL_API_ENDPOINT_V2);
	}

	@When("^I get deals through v3 endpoint$")
	public void iGetDealsThroughV3Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.POST);
		getTestContext()
				.setRequestEndpoint(EnvironmentConfig.runDealServiceLocally() ? LOCAL_DEAL_API_ENDPOINT_V3 : UAT_DEAL_API_ENDPOINT_V3);
	}

	@When("^I get charges through v2 endpoint$")
	public void iGetChargesThroughV2Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runChargeServiceLocally() ? LOCAL_CHARGE_API_ENDPOINT_V2 : UAT_CHARGE_API_ENDPOINT_V2);
	}

	@When("^I get charges through v3 endpoint$")
	public void iGetChargesThroughV3Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.POST);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runChargeServiceLocally() ? LOCAL_CHARGE_API_ENDPOINT_V3 : UAT_CHARGE_API_ENDPOINT_V3);
	}

	@When("^I get charges through pricing-engine endpoint$")
	public void iGetChargesThroughPricingEngineEndpoint() {

		getTestContext().setCustomSecondsToAwait(SECONDS_TO_AWAIT_FOR_FINAL_VALIDATION);

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext().setRequestEndpoint(EnvironmentConfig.runChargeServiceLocally() || EnvironmentConfig.runPricingEngineLocally() ?
				LOCAL_PRICING_ENGINE_CHARGE_API_ENDPOINT_V1 :
				UAT_PRICING_ENGINE_CHARGE_API_ENDPOINT_V1);
	}

	@When("^I get charges v2 through pricing-engine endpoint$")
	public void iGetChargesV2ThroughPricingEngineEndpoint() {

		getTestContext().setCustomSecondsToAwait(SECONDS_TO_AWAIT_FOR_FINAL_VALIDATION);

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext().setRequestEndpoint(EnvironmentConfig.runChargeServiceLocally() || EnvironmentConfig.runPricingEngineLocally() ?
				LOCAL_PRICING_ENGINE_CHARGE_API_ENDPOINT_V2 :
				UAT_PRICING_ENGINE_CHARGE_API_ENDPOINT_V2);
	}

	@When("^I get deals through pricing-engine endpoint$")
	public void iGetDealsThroughPricingEngineEndpoint() {

		getTestContext().setCustomSecondsToAwait(SECONDS_TO_AWAIT_FOR_FINAL_VALIDATION);

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext().setRequestEndpoint(EnvironmentConfig.runDealServiceLocally() || EnvironmentConfig.runPricingEngineLocally() ?
				LOCAL_PRICING_ENGINE_DEAL_API_ENDPOINT_V1 :
				UAT_PRICING_ENGINE_DEAL_API_ENDPOINT_V1);
	}

	@When("I get deals v2 through pricing-engine endpoint")
	public void iGetDealsV2ThroughPricingEngineEndpoint() {

		getTestContext().setCustomSecondsToAwait(SECONDS_TO_AWAIT_FOR_FINAL_VALIDATION);

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.POST);
		if (EnvironmentConfig.runPricingEngineLocally() || EnvironmentConfig.runChargeServiceLocally() || EnvironmentConfig
				.runDealServiceLocally() || EnvironmentConfig.runPriceServiceLocally()) {
			getTestContext().setRequestEndpoint(LOCAL_PRICING_ENGINE_DEAL_API_ENDPOINT_V2);
		} else {
			getTestContext().setRequestEndpoint(UAT_PRICING_ENGINE_DEAL_API_ENDPOINT_V2);
		}
	}

	@When("I get the price range through pricing-engine endpoint")
	public void iGetThePriceRangeThroughPricingEngineEndpoint() {

		getTestContext().setCustomSecondsToAwait(SECONDS_TO_AWAIT_FOR_FINAL_VALIDATION);

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext().setRequestEndpoint(EnvironmentConfig.runPricingEngineLocally() ?
				LOCAL_PRICING_ENGINE_ITEM_DISCOUNT_API_ENDPOINT_V1 :
				UAT_PRICING_ENGINE_ITEM_DISCOUNT_API_ENDPOINT_V1);
	}

	@When("^I get combos through pricing-engine endpoint$")
	public void iGetCombosThroughPricingEngineEndpoint() {

		getTestContext().setCustomSecondsToAwait(SECONDS_TO_AWAIT_FOR_FINAL_VALIDATION);

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext().setRequestEndpoint(EnvironmentConfig.runComboServiceLocally() || EnvironmentConfig.runPricingEngineLocally() ?
				LOCAL_PRICING_ENGINE_COMBO_API_ENDPOINT_V1 :
				UAT_PRICING_ENGINE_COMBO_API_ENDPOINT_V1);
	}

	@When("I get combos v2 through pricing-engine endpoint$")
	public void iGetCombosv2ThroughPricingEngineEndpoint() {

		getTestContext().setCustomSecondsToAwait(SECONDS_TO_AWAIT_FOR_FINAL_VALIDATION);

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.POST);
		getTestContext().setRequestEndpoint(EnvironmentConfig.runComboServiceLocally() || EnvironmentConfig.runPricingEngineLocally() ?
				LOCAL_PRICING_ENGINE_COMBO_API_ENDPOINT_V2 :
				UAT_PRICING_ENGINE_COMBO_API_ENDPOINT_V2);
	}

	@When("^I simulate a cart in pricing-engine endpoint$")
	public void iSimulateInPricingEngineEndpoint() {

		getTestContext().setCustomSecondsToAwait(SECONDS_TO_AWAIT_FOR_FINAL_VALIDATION);

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.POST);

		if (EnvironmentConfig.runPricingEngineLocally() || EnvironmentConfig.runChargeServiceLocally() || EnvironmentConfig
				.runDealServiceLocally() || EnvironmentConfig.runPriceServiceLocally()) {
			getTestContext().setRequestEndpoint(LOCAL_PRICING_ENGINE_API_ENDPOINT_V1);
		} else {
			getTestContext().setRequestEndpoint(UAT_PRICING_ENGINE_API_ENDPOINT_V1);
		}
	}

	@When("^I simulate a cart in pricing-engine on v2 endpoint$")
	public void iSimulateInPricingEngineV2Endpoint() {

		getTestContext().setCustomSecondsToAwait(SECONDS_TO_AWAIT_FOR_FINAL_VALIDATION);

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.POST);

		if (EnvironmentConfig.runPricingEngineLocally() || EnvironmentConfig.runChargeServiceLocally() || EnvironmentConfig
				.runDealServiceLocally() || EnvironmentConfig.runPriceServiceLocally()) {
			getTestContext().setRequestEndpoint(LOCAL_PRICING_ENGINE_API_ENDPOINT_V2);
		} else {
			getTestContext().setRequestEndpoint(UAT_PRICING_ENGINE_API_ENDPOINT_V2);
		}
	}

	@When("^I perform a get into pricing-engine simulation-v2-data endpoint$")
	public void iPerformGetIntoPricingEngineSimulationV2DataEndpoint() {

		getTestContext().setCustomSecondsToAwait(SECONDS_TO_AWAIT_FOR_FINAL_VALIDATION);

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);

		if (EnvironmentConfig.runPricingEngineLocally() || EnvironmentConfig.runChargeServiceLocally() || EnvironmentConfig
				.runDealServiceLocally() || EnvironmentConfig.runPriceServiceLocally()) {
			getTestContext().setRequestEndpoint(LOCAL_SIMULATION_DATA_API_ENDPOINT);
		} else {
			getTestContext().setRequestEndpoint(UAT_PRICING_SIMULATION_DATA_API_ENDPOINT);
		}
	}

	@When("^I get account through v1 endpoint$")
	public void iGetAccountThroughV1Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runAccountServiceLocally() ? LOCAL_ACCOUNT_API_ENDPOINT_V1 : UAT_ACCOUNT_API_ENDPOINT_V1);
	}

	@When("^I get account through v2 endpoint$")
	public void iGetAccountThroughV2Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext().setRequestEndpoint(EnvironmentConfig.runAccountServiceLocally() ?
				LOCAL_ACCOUNT_API_ENDPOINT_V2_CONTRACTS :
				UAT_ACCOUNT_API_ENDPOINT_V2_CONTRACTS);
	}

	@When("^I get items through v1 endpoint$")
	public void iGetItemsThroughV1Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext()
				.setRequestEndpoint(EnvironmentConfig.runItemServiceLocally() ? LOCAL_ITEM_API_ENDPOINT_V1 : UAT_ITEM_API_ENDPOINT_V1);
	}

	@When("^I get items through v2 endpoint$")
	public void iGetItemsThroughV2Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext()
				.setRequestEndpoint(EnvironmentConfig.runItemServiceLocally() ? LOCAL_ITEM_API_ENDPOINT_V2 : UAT_ITEM_API_ENDPOINT_V2);
	}

	@When("^I get prices offers through pricing-engine endpoint$")
	public void iGetPricesOffersThroughPricingEngineEndpoint() {

		getTestContext().setCustomSecondsToAwait(SECONDS_TO_AWAIT_FOR_FINAL_VALIDATION);

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		if (EnvironmentConfig.runPricingEngineLocally() || EnvironmentConfig.runPriceServiceLocally() || EnvironmentConfig
				.runItemServiceLocally()) {
			getTestContext().setRequestEndpoint(LOCAL_PRICING_ENGINE_OFFERS_API_ENDPOINT_V1);
		} else {
			getTestContext().setRequestEndpoint(UAT_PRICING_ENGINE_OFFERS_API_ENDPOINT_V1);
		}
	}

	@When("^I get combos through v3 endpoint$")
	public void iGetCombosThroughV3Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext()
				.setRequestEndpoint(EnvironmentConfig.runComboServiceLocally() ? LOCAL_COMBO_API_ENDPOINT_V3 : UAT_COMBO_API_ENDPOINT_V3);
	}

	@When("^I get combos through v4 endpoint$")
	public void iGetCombosThroughV4Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext()
				.setRequestEndpoint(EnvironmentConfig.runComboServiceLocally() ? LOCAL_COMBO_API_ENDPOINT_V4 : UAT_COMBO_API_ENDPOINT_V4);
	}

	@When("^I get promotion limits through v3 endpoint$")
	public void iGetEnforcementLimitsThroughV3Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext().setRequestEndpoint(EnvironmentConfig.runDealServiceLocally() ?
				LOCAL_ENFORCEMENT_LIMITS_API_ENDPOINT_V3 :
				UAT_ENFORCEMENT_LIMITS_API_ENDPOINT_V3);
	}

	@When("I get prices through v3 endpoint")
	public void iGetPricesThroughV3Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.POST);
		getTestContext()
				.setRequestEndpoint(EnvironmentConfig.runPriceServiceLocally() ? LOCAL_PRICE_API_ENDPOINT_V3 : UAT_PRICE_API_ENDPOINT_V3);
	}

	@When("I get prices offers through pricing-engine v2 endpoint")
	public void iGetPricesOffersThroughPricingEngineV2Endpoint() {

		getTestContext().setCustomSecondsToAwait(SECONDS_TO_AWAIT_FOR_FINAL_VALIDATION);

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.POST);
		if (EnvironmentConfig.runPricingEngineLocally() || EnvironmentConfig.runPriceServiceLocally() || EnvironmentConfig
				.runItemServiceLocally()) {
			getTestContext().setRequestEndpoint(LOCAL_PRICING_ENGINE_OFFERS_API_ENDPOINT_V2);
		} else {
			getTestContext().setRequestEndpoint(UAT_PRICING_ENGINE_OFFERS_API_ENDPOINT_V2);
		}
	}

	@When("I get delivery windows through v1 endpoint")
	public void iGetDeliveryWindowsThroughV1Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runPriceServiceLocally() ? LOCAL_DELIVERY_WINDOW_API_ENDPOINT_V1 : UAT_DELIVERY_WINDOW_API_ENDPOINT_V1);
	}

	@When("I get the price range through pricing-engine v2 endpoint")
	public void iGetThePriceRangeThroughPricingEngineV2Endpoint() {

		getTestContext().setCustomSecondsToAwait(SECONDS_TO_AWAIT_FOR_FINAL_VALIDATION);

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.POST);
		getTestContext().setRequestEndpoint(EnvironmentConfig.runPricingEngineLocally() ?
				LOCAL_PRICING_ENGINE_ITEM_DISCOUNT_API_ENDPOINT_V2 :
				UAT_PRICING_ENGINE_ITEM_DISCOUNT_API_ENDPOINT_V2);
	}

	@When("^I get promotion limits through v4 endpoint$")
	public void iGetEnforcementLimitsThroughV4Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext().setRequestEndpoint(EnvironmentConfig.runDealServiceLocally() ?
				LOCAL_ENFORCEMENT_LIMITS_API_ENDPOINT_V4 :
				UAT_ENFORCEMENT_LIMITS_API_ENDPOINT_V4);
	}

	@When("^I get empties through v2 endpoint$")
	public void iGetEmptiesThroughV2Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.GET);
		getTestContext().setRequestEndpoint(EnvironmentConfig.runDealServiceLocally() ?
				LOCAL_EMPTY_API_ENDPOINT_V2 :
				UAT_EMPTY_API_ENDPOINT_V2);

	}
}
