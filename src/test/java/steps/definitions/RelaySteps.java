package steps.definitions;

import static configs.EnvironmentConstants.LOCAL_ACCOUNT_RELAY_ENDPOINT_V1;
import static configs.EnvironmentConstants.LOCAL_CHARGE_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.LOCAL_CHARGE_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.LOCAL_COMBO_RELAY_DDC_ENDPOINT_V3;
import static configs.EnvironmentConstants.LOCAL_COMBO_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.LOCAL_COMBO_SCORE_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.LOCAL_DEAL_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.LOCAL_DEAL_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.LOCAL_DELIVERY_WINDOW_RELAY_ENDPOINT_V1;
import static configs.EnvironmentConstants.LOCAL_EMPTY_RELAY_ENDPOINT_V1;
import static configs.EnvironmentConstants.LOCAL_ENFORCEMENT_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.LOCAL_ITEM_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.LOCAL_PRICE_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.LOCAL_PRICE_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.LOCAL_PROMOTION_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.LOCAL_SORTED_DEAL_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.UAT_ACCOUNT_RELAY_ENDPOINT_V1;
import static configs.EnvironmentConstants.UAT_CHARGE_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.UAT_CHARGE_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.UAT_COMBO_RELAY_DDC_ENDPOINT_V3;
import static configs.EnvironmentConstants.UAT_COMBO_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.UAT_COMBO_SCORE_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.UAT_DEAL_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.UAT_DEAL_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.UAT_DELIVERY_WINDOW_RELAY_ENDPOINT_V1;
import static configs.EnvironmentConstants.UAT_EMPTY_RELAY_ENDPOINT_V1;
import static configs.EnvironmentConstants.UAT_ENFORCEMENT_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.UAT_ITEM_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.UAT_PRICE_RELAY_ENDPOINT_V2;
import static configs.EnvironmentConstants.UAT_PRICE_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.UAT_PROMOTION_RELAY_ENDPOINT_V3;
import static configs.EnvironmentConstants.UAT_SORTED_DEAL_RELAY_ENDPOINT_V3;
import static helpers.TestConstants.APPLICATION_JSON;
import static helpers.TestConstants.CONTENT_TYPE_HEADER;
import static helpers.TestConstants.DELIVERY_CENTER_IDS_PATH;

import java.util.Map;

import configs.EnvironmentConfig;
import helpers.BaseStepDefinitions;
import io.cucumber.java.en.When;
import io.restassured.http.Method;

public class RelaySteps extends BaseStepDefinitions {

	@When("^I create prices through v2 endpoint$")
	public void iCreatePricesThroughV2Endpoint() {

		putContentTypeIntoRequestHeaders();

		getTestContext().setRequestMethod(Method.PUT);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runPriceServiceLocally() ? LOCAL_PRICE_RELAY_ENDPOINT_V2 : UAT_PRICE_RELAY_ENDPOINT_V2);
		getTestContext().getDataCreatedInTestContext().setDataCreatedInPriceRelayV2(true);
	}

	@When("^I create prices through v3 endpoint$")
	public void iCreatePricesThroughV3Endpoint() {

		putContentTypeIntoRequestHeaders();

		getTestContext().setRequestMethod(Method.PUT);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runPriceServiceLocally() ? LOCAL_PRICE_RELAY_ENDPOINT_V3 : UAT_PRICE_RELAY_ENDPOINT_V3);
		getTestContext().getDataCreatedInTestContext().setDataCreatedInPriceRelayV3(true);
	}

	@When("^I create deals through v2 endpoint$")
	public void iCreateDealsThroughV2Endpoint() {

		putContentTypeIntoRequestHeaders();

		getTestContext().setRequestMethod(Method.PUT);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runDealServiceLocally() ? LOCAL_DEAL_RELAY_ENDPOINT_V2 : UAT_DEAL_RELAY_ENDPOINT_V2);
		getTestContext().getDataCreatedInTestContext().setDataCreatedInDealRelayV2(true);
	}

	@When("^I create charges through v2 endpoint$")
	public void iCreateChargesThroughV2Endpoint() {

		putContentTypeIntoRequestHeaders();

		getTestContext().setRequestMethod(Method.PUT);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runChargeServiceLocally() ? LOCAL_CHARGE_RELAY_ENDPOINT_V2 : UAT_CHARGE_RELAY_ENDPOINT_V2);
		getTestContext().getDataCreatedInTestContext().setDataCreatedInChargeRelayV2(true);
	}

	@When("^I create charges through v3 endpoint$")
	public void iCreateChargesThroughV3Endpoint() {

		final Map<String, Object> headers = getTestContext().getRequestHeaders();
		headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

		getTestContext().setRequestMethod(Method.PUT);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runChargeServiceLocally() ? LOCAL_CHARGE_RELAY_ENDPOINT_V3 : UAT_CHARGE_RELAY_ENDPOINT_V3);
	}

	@When("^I create account through v1 endpoint$")
	public void iCreateAccountThroughV1Endpoint() {

		putContentTypeIntoRequestHeaders();

		getTestContext().setRequestMethod(Method.POST);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runAccountServiceLocally() ? LOCAL_ACCOUNT_RELAY_ENDPOINT_V1 : UAT_ACCOUNT_RELAY_ENDPOINT_V1);
		getTestContext().getDataCreatedInTestContext().setDataCreatedInAccountRelayV1(true);
	}

	@When("^I create combos through v3 endpoint$")
	public void iCreateCombosThroughV3Endpoint() {

		putContentTypeIntoRequestHeaders();

		getTestContext().setRequestMethod(Method.POST);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runComboServiceLocally() ? LOCAL_COMBO_RELAY_ENDPOINT_V3 : UAT_COMBO_RELAY_ENDPOINT_V3);
		getTestContext().getDataCreatedInTestContext().setDataCreatedInComboRelayV3(true);
	}

	@When("^I create combos with DDC through v3 endpoint$")
	public void iCreateCombosWithDDCThroughV3Endpoint() {

		putContentTypeIntoRequestHeaders();

		getTestContext().setRequestMethod(Method.POST);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runComboServiceLocally() ? LOCAL_COMBO_RELAY_DDC_ENDPOINT_V3 : UAT_COMBO_RELAY_DDC_ENDPOINT_V3);
		getTestContext().getDataCreatedInTestContext().setDataCreatedInComboRelayV3(true);
	}

	@When("^I create items through v2 endpoint$")
	public void iCreateItemsThroughV2Endpoint() {

		putContentTypeIntoRequestHeaders();

		getTestContext().setRequestMethod(Method.PUT);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runItemServiceLocally() ? LOCAL_ITEM_RELAY_ENDPOINT_V2 : UAT_ITEM_RELAY_ENDPOINT_V2);
	}

	@When("^I create promotion limit through v2 endpoint$")
	public void iCreateEnforcementLimitThroughV2Endpoint() {

		putContentTypeIntoRequestHeaders();

		getTestContext().setRequestMethod(Method.POST);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runEnforcementServiceLocally() ? LOCAL_ENFORCEMENT_RELAY_ENDPOINT_V2 : UAT_ENFORCEMENT_RELAY_ENDPOINT_V2);
	}

	@When("^I create delivery windows through v1 endpoint$")
	public void iCreateDeliveryWindowsThroughV1Endpoint() {

		putContentTypeIntoRequestHeaders();

		getTestContext().setRequestMethod(Method.POST);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runPriceServiceLocally() ?
						LOCAL_DELIVERY_WINDOW_RELAY_ENDPOINT_V1 :
						UAT_DELIVERY_WINDOW_RELAY_ENDPOINT_V1);
		getTestContext().getDataCreatedInTestContext().setDataCreatedInDeliveryWindowRelayV1(true);
	}

	@When("^I create empties for ddc \"([^\"]*)\" through v1 endpoint$")
	public void iCreateEmptiesThroughV1Endpoint(final String ddc) {

		putContentTypeIntoRequestHeaders();

		getTestContext().setRequestMethod(Method.POST);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runEmptyServiceLocally() ? LOCAL_EMPTY_RELAY_ENDPOINT_V1
						: UAT_EMPTY_RELAY_ENDPOINT_V1.replace(DELIVERY_CENTER_IDS_PATH, ddc));
	}

	@When("^I update deals through v3 endpoint$")
	public void iUpdateDealsThroughV3Endpoint() {

		putContentTypeIntoRequestHeaders();

		getTestContext().setRequestMethod(Method.PATCH);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runDealServiceLocally() ? LOCAL_SORTED_DEAL_RELAY_ENDPOINT_V3 : UAT_SORTED_DEAL_RELAY_ENDPOINT_V3);
		getTestContext().getDataCreatedInTestContext().setDataCreatedInDealRelayV3(true);
	}

	@When("^I update combos through v3 endpoint$")
	public void iUpdateCombosThroughV3Endpoint() {

		putContentTypeIntoRequestHeaders();

		getTestContext().setRequestMethod(Method.PATCH);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runDealServiceLocally() ? LOCAL_COMBO_SCORE_RELAY_ENDPOINT_V3 : UAT_COMBO_SCORE_RELAY_ENDPOINT_V3);
		getTestContext().getDataCreatedInTestContext().setDataCreatedInComboScoreRelayV3(true);
	}

	@When("^I create promotion through v3 endpoint$")
	public void iCreatePromotionThroughV3Endpoint() {

		putContentTypeIntoRequestHeaders();

		getTestContext().setRequestMethod(Method.POST);
		getTestContext().setRequestEndpoint(EnvironmentConfig.runAccountServiceLocally() ? LOCAL_PROMOTION_RELAY_ENDPOINT_V3 :
				UAT_PROMOTION_RELAY_ENDPOINT_V3);
		getTestContext().getDataCreatedInTestContext().setDataCreatedInPromotionRelayV3(true);
	}

	@When("^I create deals through v3 endpoint$")
	public void iCreateDealsThroughV3Endpoint() {

		putContentTypeIntoRequestHeaders();

		getTestContext().setRequestMethod(Method.PUT);
		getTestContext().setRequestEndpoint(
				EnvironmentConfig.runDealServiceLocally() ? LOCAL_DEAL_RELAY_ENDPOINT_V3 : UAT_DEAL_RELAY_ENDPOINT_V3);
		getTestContext().getDataCreatedInTestContext().setDataCreatedInDealRelayV3(true);
	}

	private void putContentTypeIntoRequestHeaders() {

		getTestContext().getRequestHeaders().put(CONTENT_TYPE_HEADER, APPLICATION_JSON);
	}
}