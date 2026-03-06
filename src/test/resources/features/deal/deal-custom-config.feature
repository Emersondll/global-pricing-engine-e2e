@ok
Feature: I want to get the deals on pricing-engine/deals v1, with vendor with custom configuration

  Scenario Outline: Validate retrieve deals with vendor that have custom configurations through pricing-engine v1 endpoint
  - Scenario 01: Vendor BRF
  -- Configurations:
  --- lineItemTotalRoundingStrategy: HALF_UP
  --- isAllowedCloseRanges: false

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Price
    Given I have the payload at file "br-create-prices-v2-for-custom-configs" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price"
    When I create prices through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deal
    Given I have the payload at file "<deal-request>" at folder "deal-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through v2 endpoint
    Then The response code is "202" and the body is blank

    # GET Price
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "timezone" header with value "<timezone>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # GET Deal
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "timezone" header with value "<timezone>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-deal"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-response>" at folder "deal-service"

    # GET Deal through pricing-engine
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "timezone" header with value "<timezone>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-deal"
    * I have the "projection" param with value "<projection>"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<deals-preview-response>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | projection | price-file-name                          | deal-request                          | deal-response                          | deals-preview-response                         |
      | BR      | America/Sao_Paulo | 3c5eece4-ac37-44e3-a95e-a264802a7dfe | PRICED     | br-prices-v2-response-for-custom-configs | br-create-deals-v2-for-custom-configs | br-deals-v2-response-for-custom-config | br-deals-preview-v2-response-for-custom-config |