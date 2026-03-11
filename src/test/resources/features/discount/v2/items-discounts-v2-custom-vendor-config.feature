@ok
Feature: I want to see my promotions screen in marketplace using vendor config lineItemTotalRoundingStrategy "UP"

  Scenario Outline: Validate retrieve a price range through pricing-engine v2 endpoint (including prices with taxes.proportional true)
  -- Vendor BRF
  -- Configurations:
  --- lineItemTotalRoundingStrategy: UP
  --- isAllowedCloseRanges: false

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Prices
    Given  I have the payload at file "<price-relay-request>" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3-"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deals
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "<deal-relay-request>" at folder "deal-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal-vendor-1"
    When I create deals through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Items
    Given I have the payload at file "<item-file-name>" at folder "item-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-put-item-v2"
    * I set the token to the vendorId "<vendorId>"
    When I create items through v2 endpoint
    Then The response code is "202" and the body is blank

    # POST Prices
    Given I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-post-price-v3-all-vendors"
    * I have the payload at file "<price-file-name>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # POST Deals
    Given I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-post-deal-all-vendors"
    * I have the payload at file "<deal-file-name>" at folder "deal-service"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-file-name>" at folder "deal-service"

    # GET Items
    Given I have the "vendorId" param with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-get-item"
    * I have the "vendorItemIds" param with value "<vendorItemIds>"
    * I set the token to the vendorId "<vendorId>"
    When I get items through v2 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<item-file-name>" at folder "item-service"

    # GET Item Discount V2 (Price Range)
    Given I have the payload at file "<item-discount-file-name>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-get-item-discount-v2"
    * I set the token to the vendorId "<vendorId>"
    When I get the price range through pricing-engine v2 endpoint
    Then The response code is "200" and the body matches the json at file "<item-discount-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | price-relay-request         | price-file-name      | deal-relay-request                        | deal-file-name                     | vendorItemIds               | item-file-name                | item-discount-file-name                   |
      # Vendor BRF
      | BR      | America/Sao_Paulo | 3c5eece4-ac37-44e3-a95e-a264802a7dfe | br-create-prices-v3-per-uom | br-prices-v3-per-uom | br-create-deals-v3-lineItemScaledDiscount | br-deals-v3-lineItemScaledDiscount | VENDOR-ITEM-1-BEESPR-T20131 | br-items-v2-for-price-per-uom | br-item-discounts-v2-custom-vendor-config |
