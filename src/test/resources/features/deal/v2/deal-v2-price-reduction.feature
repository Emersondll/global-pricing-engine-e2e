@ignore
Feature: I want to get deals with price reduction on pricing-engine/deals v2

  Scenario Outline: Validate through pricing-engine v2 deals with price reduction

    # Generate Market Place Ids, token and taxId
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I generate the token to the vendorId "<vendorId>"
    * I set the timezone to the "<country>"

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
    * I have the requestTraceId header with value starting with a "e2e-put-deal-v3-vendor-1"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through v3 endpoint
    Then The response code is "202" and the body is blank

    # POST Prices
    Given I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-post-price-v3-all-vendors"
    * I have the payload at file "<price-api-request>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-api-response>" at folder "price-service"

    # POST Deals
    Given I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-post-deal-all-vendors"
    * I have the payload at file "<deal-api-request>" at folder "deal-service"
    * I set the token to the vendorId "<vendorId>"
    * I have the "types" param with list values
      | PALLET_DISCOUNT   |
      | REGULAR_DISCOUNT  |
      | ORDER_DISCOUNT    |
      | FREE_GOOD         |
      | FLEXIBLE_DISCOUNT |
      | SCALED_DISCOUNT   |
      | SCALED_FREE_GOOD  |
      | COUPON            |
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-api-response>-part-1" at folder "deal-service"

    # POST Deals
    Given I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-post-deal-all-vendors"
    * I have the payload at file "<deal-api-request>" at folder "deal-service"
    * I set the token to the vendorId "<vendorId>"
    * I have the "types" param with list values
      | PRICE_REDUCTION |
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-api-response>-part-2" at folder "deal-service"

    # POST Deal V2 through pricing-engine
    Given I have the payload at file "<deal-v2-file-name>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-pricing-engine-deals-v2"
    * I have the "timezone" header with value "<timezone>"
    * I set the token to the vendorId "<vendorId>"
    When I get deals v2 through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<deal-v2-file-name-response>" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             | timezone          | price-relay-request         | deal-relay-request                    | price-api-request                   | price-api-response          | deal-api-request                           | deal-api-response                     | deal-v2-file-name          | deal-v2-file-name-response |
      | BR      | d8e9fbc3-0678-4778-beb7-74165906d3fa | America/Sao_Paulo | br-price-v3-price-reduction | br-deals-v3-line-item-price-reduction | br-price-v3-request-price-reduction | br-price-v3-price-reduction | br-request-deals-line-item-price-reduction | br-deals-v3-line-item-price-reduction | br-deal-v2-price-reduction | br-deal-v2-price-reduction |
