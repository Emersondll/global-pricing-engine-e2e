@ok
Feature: I want to see my promotions screen in marketplace when have enforced discounts

  Scenario Outline: Validate retrieve a price range through pricing-engine v2 endpoint when have enforced discounts

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I generate the token to the vendorId "<vendorId>"
    * I have the "vendorId" header with value "<vendorId>"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I set the timezone to the "<country>"

    # PUT Price
    Given I have the payload at file "<price-file-name>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deal
    Given I have the payload at file "<deal-file-name>" at folder "deal-service"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal"
    When I create deals through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Enforcement V2 Limit
    Given I have the payload at file "<enforcement-file-name>" at folder "enforcement-service"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-enforcement-v2"
    When I create promotion limit through v2 endpoint
    Then The response code is "202" and the body is blank

    # GET Price
    Given I have the "country" header with value "<country>"
    * I set the token to the vendorId "<vendorId>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "pe-prices-v3-for-item-discount-v2-put-request" at folder "price-service"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # GET Deal
    Given I have the "vendorId" header with value "<vendorId>"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "pe-v3-request-deals-enforced" at folder "deal-service"
    * I have dynamic market place ids
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-file-name>" at folder "deal-service"

    # GET Enforcement V4 limit
    Given I have the "country" header with value "<country>"
    * I set the token to the vendorId "<vendorId>"
    * I have the requestTraceId header with value starting with a "e2e-get-enforcement-v4"
    * I have the "beesAccountId" param with value dynamic beesAccountId
    * I have the enforcement params with "1", "1", "<vendorId>", "PROMOTION" and "PROMO-BEESPR-19416-1"
    * I have the enforcement params with "1", "2", "<vendorId>", "PROMOTION" and "PROMO-BEESPR-19416-3"
    When I get promotion limits through v4 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<enforcement-file-name>" at folder "enforcement-service"

    # GET Item Discount V2 (Price Range)
    Given I have the payload at file "<item-discount-file-name>" at folder "pricing-engine"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-item-discount-v2"
    When I get the price range through pricing-engine v2 endpoint
    Then The response code is "200" and the body matches the json at file "<item-discount-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | timezone     | vendorId                             | price-file-name                   | deal-file-name                         | enforcement-file-name                  | item-discount-file-name             |
      | PE      | America/Lima | badb25b3-f4be-4bf3-b635-910d6d62271e | pe-prices-v3-for-item-discount-v2 | pe-deals-enforced-v2-item-discounts-v2 | pe-enforcement-limits-item-discount-v2 | pe-item-discounts-v2-enforced-deals |