@ok
Feature: I want to validate prices and charges registered through the data ingestion in simulation/v2

  Scenario Outline:  Simulation V2 with prices and charges registered through the data ingestion

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId>"
    * I generate the token to the vendorId "<vendorId>"
    * I set the timezone to the "<country>"

     # PUT Prices to VENDOR 1 with prices type VENDOR through data-ingestion
    Given I have the payload at file "<country>-prices-v3-charges-v3-simulation-v2-vendor" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through data-ingestion
    Then The response code is "202" and the body is blank

    # PUT Prices to VENDOR 1 with prices type ACCOUNT through data-ingestion
    Given I have the payload at file "<country>-prices-v3-charges-v3-simulation-v2-account" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through data-ingestion
    Then The response code is "202" and the body is blank

     # PUT Prices to VENDOR 1 with prices type DELIVERY_CENTER through data-ingestion
    Given I have the payload at file "<country>-prices-v3-charges-v3-simulation-v2-ddc" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through data-ingestion
    Then The response code is "202" and the body is blank

    # PUT Charges of type VENDOR through data-ingestion
    Given I have the payload at file "<country>-charges-v3-simulation-v2-vendor" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    * I set the token to the vendorId "<vendorId>"
    When I create charges through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT Charges of type ACCOUNT through data-ingestion
    Given I have the payload at file "<country>-charges-v3-simulation-v2-account" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    * I set the token to the vendorId "<vendorId>"
    When I create charges through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT Charges of  type DELIVERY_CENTER through data-ingestion
    Given I have the payload at file "<country>-charges-v3-simulation-v2-ddc" at folder "data-ingestion"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    * I set the token to the vendorId "<vendorId>"
    When I create charges through data ingestion endpoint
    Then The response code is "202" and the body is blank

    #GET Prices
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "<country>-prices-v3-request-charges-v3-simulation-v2" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-prices-v3-charges-v3-simulation-v2" at folder "price-service"

    # GET Charges
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-charge"
    * I have the payload at file "<country>-charges-v3-request-simulation-v2" at folder "charge-service"
    * I set the token to the vendorId "<vendorId>"
    When I get charges through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-charges-v3-simulation-v2" at folder "charge-service"

    # Simulation
    Given I have the payload at file "<country>-simulation-v2-with-charges" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-simulation-v2-with-charges" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             |
      | BR      | eafe490e-fddc-4b01-900a-d0dc45194ab6 |