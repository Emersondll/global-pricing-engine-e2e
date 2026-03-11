@later
Feature: I want to get the deals v2 created in the data ingestion

  Scenario Outline: Validate retrieving deals v2 of types VENDOR, DELIVERY CENTER, and ACCOUNT  created at data ingestion

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic price list Id for key "1"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Prices for Account
    Given I have the payload at file "br-prices-v3-deals-v2-account-ambev" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Prices for ddc
    Given I have the payload at file "br-prices-v3-deals-v2-ddc-<vendor>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT vendor deal through data ingestion
    Given I have the payload at file "<country>-deals-v3-vendor-<vendor>" at folder "data-ingestion"
    * I set the token to the vendorId "<vendorId>"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-vendor-deal"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT ddc deal through data ingestion
    Given I have the payload at file "<country>-deals-v3-ddc-<vendor>" at folder "data-ingestion"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-ddc-deal"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT account deal through data ingestion
    Given I have the payload at file "<country>-deals-v3-account" at folder "data-ingestion"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-account-deal"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # POST to get the prices
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "br-v3-deals-v2-request-<vendor>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "br-prices-v3-deals-v2-<vendor>" at folder "price-service"

    # POST to get deals
    Given I have the "country" header with value "<country>"
    * I set the token to the vendorId "<vendorId>"
    * I have the requestTraceId header with value starting with a "e2e-post-deal-all"
    * I have the payload at file "br-deals-v3-post-request-data-ingestion-<vendor>" at folder "deal-service"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "br-deals-v3-data-ingestion-<vendor>" at folder "deal-service"

    # GET Deal V2 through pricing-engine
    Given I have the payload at file "<pricing-engine-deal-file>" at folder "pricing-engine"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-post-pricing-engine-deals-v2"
    When I get deals v2 through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<pricing-engine-deal-file>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendor | vendorId                             | pricing-engine-deal-file          |
      | BR      | America/Sao_Paulo | ambev  | 7a51f522-c3e3-421b-89d8-290d8eb2eddd | br-deals-v2-data-ingestion        |
      | BR      | America/Sao_Paulo | custom | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-deals-v2-data-ingestion-custom |
