@ok
Feature: I want to get the prices offers available for a customer

  Scenario Outline: Validate retrieve prices offers through pricing-engine endpoint

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"

    # PUT Prices
    Given I have the payload at file "<price-file-name>" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Items
    Given I have the payload at file "<item-file-name>" at folder "item-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-item"
    * I set the token to the vendorId "<vendorId>"
    When I create items through v2 endpoint
    Then The response code is "202" and the body is blank

    # GET Prices
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # GET Item
    Given I have the "vendorId" param with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-item"
    * I have the "vendorItemIds" param with value "<vendorItemIds>"
    * I set the token to the vendorId "<vendorId>"
    When I get items through v1 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<item-file-name>" at folder "item-service"

    # GET Prices Offers through pricing-engine
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-offers"
    * I set the token to the vendorId "<vendorId>"
    When I get prices offers through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<offers-response>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | price-file-name | item-file-name | offers-response | vendorItemIds                                                                                                                                                                         |
      | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-prices-v3    | br-items       | br-offers       | VENDOR-SKU-BEESPR-14278-1,VENDOR-SKU-BEESPR-14278-2,VENDOR-SKU-BEESPR-14278-5,VENDOR-SKU-BEESPR-14277-2,VENDOR-SKU-BEESPR-14277-3,VENDOR-SKU-BEESPR-14277-4,VENDOR-SKU-BEESPR-14277-5 |
