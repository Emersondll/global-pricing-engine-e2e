@ok
Feature: I want to get the items discounts with deals v3 created at the data ingestion

  Scenario Outline: Validate retrieving items discounts with deals v3 of types VENDOR, DELIVERY CENTER, and ACCOUNT created at data ingestion

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I generate the token to the vendorId "<vendorId>"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic price list Id for key "1"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId>"

    # PUT Prices
    Given I have the payload at file "<country>-prices-v3-item-discounts-v2-account" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT vendor deal through data ingestion
    Given I have the payload at file "<country>-deals-v3-item-discounts-v2-vendor" at folder "data-ingestion"
    * I set the token to the vendorId "<vendorId>"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-vendor-deal"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT ddc deal through data ingestion
    Given I have the payload at file "<country>-deals-v3-item-discounts-v2-ddc" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-ddc-deal"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT account deal through data ingestion
    Given I have the payload at file "<country>-deals-v3-item-discounts-v2-account" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-account-deal"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT Items
    Given I have the payload at file "<country>-items-v2-item-discounts-v2" at folder "item-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-item-v2"
    * I set the token to the vendorId "<vendorId>"
    When I create items through v2 endpoint
    Then The response code is "202" and the body is blank

    # POST to get the prices
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "<country>-prices-v3-item-discounts-v2-request" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-prices-v3-item-discounts-v2" at folder "price-service"

    # POST to get deals
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-deal-all"
    * I have the payload at file "<country>-deals-v3-post-request-item-discounts-v2" at folder "deal-service"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-deals-v3-item-discounts-v2" at folder "deal-service"

    # GET Items
    Given I have the "vendorId" param with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-item"
    * I have the "vendorItemIds" param with value "VENDOR-ITEM-BEESPR-17374"
    * I set the token to the vendorId "<vendorId>"
    When I get items through v2 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<country>-items-v2-item-discounts-v2" at folder "item-service"

    # GET Item Discounts V2 (Price Range)
    Given I have the payload at file "<item-discounts-file-name>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-item-discounts-v2"
    * I set the token to the vendorId "<vendorId>"
    When I get the price range through pricing-engine v2 endpoint
    Then The response code is "200" and the body matches the json at file "<item-discounts-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | item-discounts-file-name  |
      | BR      | America/Sao_Paulo | 7a51f522-c3e3-421b-89d8-290d8eb2eddd | BR-item-discounts-v2-BEST |
      | EC      | America/Guayaquil | 6b1c3a4d-5385-49fc-937c-eff4282b4388 | EC-item-discounts-v2-ALL  |