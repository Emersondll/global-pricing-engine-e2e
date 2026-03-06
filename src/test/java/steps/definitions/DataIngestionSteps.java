package steps.definitions;

import static configs.EnvironmentConstants.UAT_DATA_INGESTION_ENDPOINT_V1;
import static helpers.TestConstants.APPLICATION_JSON;
import static helpers.TestConstants.CONTENT_TYPE_HEADER;

import java.util.Map;

import helpers.BaseStepDefinitions;
import io.cucumber.java.en.When;
import io.restassured.http.Method;

public class DataIngestionSteps extends BaseStepDefinitions {
	private void createDataThroughPutDataIngestionEndpoint() {

        final Map<String, Object> headers = getTestContext().getRequestHeaders();
        headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

        getTestContext().setRequestMethod(Method.PUT);
        getTestContext().setRequestEndpoint(UAT_DATA_INGESTION_ENDPOINT_V1);
    }

    private void createDataThroughPostDataIngestionEndpoint() {
        final Map<String, Object> headers = getTestContext().getRequestHeaders();
        headers.put(CONTENT_TYPE_HEADER, APPLICATION_JSON);

        getTestContext().setRequestMethod(Method.POST);
        getTestContext().setRequestEndpoint(UAT_DATA_INGESTION_ENDPOINT_V1);
    }

    @When("^I create deals through data ingestion endpoint$")
    public void iCreateDealsThroughPutV2Endpoint() {
        createDataThroughPutDataIngestionEndpoint();
    }

    @When("^I create prices through data-ingestion$")
    public void iCreatePricesThroughPutDataIngestionEndpoint() {
        createDataThroughPutDataIngestionEndpoint();
        getTestContext().getDataCreatedInTestContext().setDataCreatedInPriceRelayV3(true);
    }

    @When("^I create charges through data ingestion endpoint$")
    public void iCreateChargesThroughV2Endpoint() {
        createDataThroughPutDataIngestionEndpoint();
    }

    @When("^I create combos through data ingestion endpoint$")
    public void iCreateCombosThroughV3Endpoint() {
        createDataThroughPostDataIngestionEndpoint();
    }
}
