@ok
Feature: I want to be able to simulation in pricing-engine/v2, with deal with coupon limited

  Scenario Outline: Simulation V2 of prices, deal lineitem and deal with coupon limited >= maxAmount and total >= conditions.amounts

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

    # Simulation
    Given I have the payload at file "<simulation-request>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I put the timezone header
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "<simulation-response>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | price-relay-request        | price-api-request           | price-api-response           | deal-relay-request                      | deal-api-request                         | deal-api-response                         | simulation-request                      | simulation-response                      |
      | BR      | America/Sao_Paulo | 3c5eece4-ac37-44e3-a95e-a264802a7dfe | br-create-prices-v3-coupon | br-request-prices-v3-coupon | br-response-prices-v3-coupon | br-create-deals-v3-simulation-v2-coupon | br-request-deals-v3-simulation-v2-coupon | br-response-deals-v3-simulation-v2-coupon | br-simulation-v2-request-coupon-limited | br-simulation-v2-response-coupon-limited |
