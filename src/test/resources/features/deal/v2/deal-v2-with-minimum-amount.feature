@ignore
Feature: I want to get deals with minimum amount on pricing-engine/deals v2

  Scenario Outline: Validate through pricing-engine v2 deals with minimum amount

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
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-api-response>" at folder "deal-service"

    # POST Deal V2 through pricing-engine
    Given I have the payload at file "<deal-v2-file-name>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-pricing-engine-deals-v2"
    * I have the "timezone" header with value "<timezone>"
    * I set the token to the vendorId "<vendorId>"
    When I get deals v2 through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<deal-v2-file-name-response>" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             | timezone          | price-relay-request                       | deal-relay-request                                 | price-api-request                       | price-api-response                       | deal-api-request                       | deal-api-response                       | deal-v2-file-name         | deal-v2-file-name-response |
      | EC      | 70b33632-6bce-4eeb-95a2-ba0be90bf908 | America/Guayaquil | ec-prices-v3-relay-request-minimum-amount | ec-deals-v3-relay-request-free-good-minimum-amount | ec-prices-v3-api-request-minimum-amount | ec-prices-v3-api-response-minimum-amount | ec-deals-v3-api-request-minimum-amount | ec-deals-v3-api-response-minimum-amount | ec-deal-v2-minimum-amount | ec-deal-v2-minimum-amount  |