@ok
Feature: I want to be able to validate the Simulation price with decimal places with vendor config

  Scenario Outline: Simulation V2 with prices with taxes and discount observing total decimal places

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic price list Id for key "1"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Prices to VENDOR 1 with prices type ACCOUNT through price-relay
    Given I have the payload at file "<price-relay-request>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I put the timezone header
    * I have the x-timestamp header with current time
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # GET Prices
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "<price-api-request>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-api-response>" at folder "price-service"

    # PUT Deals
    Given I have the payload at file "<deal-relay-request>" at folder "deal-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal-v2"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through v3 endpoint
    Then The response code is "202" and the body is blank

    # POST to get Deals
    Given I have the "country" header with value "<country>"
    * I set the token to the vendorId "<vendorId>"
    * I have the requestTraceId header with value starting with a "e2e-post-deal"
    * I have the payload at file "<deal-api-request>" at folder "deal-service"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-api-response>" at folder "deal-service"

    # Simulation
    Given I have the payload at file "EC-simulation-request-with-item-taxes-and-discount" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "EC-simulation-response-with-item-taxes-and-discount" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             | timezone            | price-relay-request               | price-api-request                  | price-api-response                  | deal-relay-request          | deal-api-request             | deal-api-response             |
      | EC      | 70b33632-6bce-4eeb-95a2-ba0be90bf908 | America/Guayaquil   | EC-create-prices-v3-item-with-IVA | EC-request-prices-v3-item-with-IVA | EC-response-prices-v3-item-with-IVA | ec-create-deals-v3-discount | ec-request-deals-v3-discount | ec-response-deals-v3-discount |
