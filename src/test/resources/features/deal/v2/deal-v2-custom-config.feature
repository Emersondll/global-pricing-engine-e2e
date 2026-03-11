@ignore
Feature: I want to get the deals on pricing-engine/deals v2, with vendor with custom configuration

  Scenario Outline: Validate retrieve deals with vendor that have custom configurations through pricing-engine v2 endpoint
  - Scenario 01: Vendor BRF
  -- Configurations:
  --- lineItemTotalRoundingStrategy: HALF_UP
  --- isAllowedCloseRanges: false
    # Generate Market Place Ids, token and taxId
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Prices with type ACCOUNT
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "br-create-prices-v3-for-custom-configs" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3-vendor-1"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deals with type ACCOUNT
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "br-create-deals-v3-for-custom-configs" at folder "deal-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal-vendor-1"
    When I create deals through v2 endpoint
    Then The response code is "202" and the body is blank

    # POST Prices
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-price-v3-all-vendors"
    * I have the payload at file "<price-request-file-name>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # POST Deals
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-deal-all-vendors"
    * I have the payload at file "br-deals-v3-post-request-for-custom-configs" at folder "deal-service"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "br-deals-v3-post-response-for-custom-configs" at folder "deal-service"

    # POST Deal V2 through pricing-engine
    Given I have the payload at file "<deal-v2-file-name>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-pricing-engine-deals-v2"
    * I have the "timezone" header with value "<timezone>"
    * I set the token to the vendorId "<vendorId>"
    When I get deals v2 through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<deal-v2-file-name-response>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | price-request-file-name                      | price-file-name                               | deal-v2-file-name                           | deal-v2-file-name-response                   |
      | BR      | America/Sao_Paulo | 3c5eece4-ac37-44e3-a95e-a264802a7dfe | br-prices-v3-post-request-for-custom-configs | br-prices-v3-post-response-for-custom-configs | deals-preview-v2-request-for-custom-configs | deals-preview-v2-response-for-custom-configs |