@ok
Feature: I want to simulation in v2 endpoint combos with free goods available for a customer

  Scenario Outline: I want to simulation in v2 endpoint combos with free goods available for a customer

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I generate the token to the vendorId "<vendorId>"
    * I set the timezone to the "<country>"

    # PUT Price
    Given I have the payload at file "create-prices-v3-simulation-v2-combos-with-free-goods" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-price"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v2 endpoint
    Then The response code is "202" and the body is blank

    # POST Combos for account
    Given I have the payload at file "create-combos-with-free-goods-v3-simulation-v2" at folder "combo-service"
    * I have the "country" header with value "<country>"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the requestTraceId header with value starting with a "e2e-post-combo"
    * I put the timezone header
    * I set the token to the vendorId "<vendorId>"
    When I create combos through v3 endpoint
    Then The response code is "202" and the body is blank

    # GET Prices
    Given I have the payload at file "request-get-prices-v3-simulation-v2-combos-with-free-goods" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "response-get-prices-v3-simulation-v2-combos-with-free-goods" at folder "price-service"

    # GET Combos for Account
    Given I have the "country" header with value "<country>"
    * I have combo account platform Id for key "1" with comboId "VENDOR-COMBO-BEESPR-21841-1" and vendorId "<vendorId>"
    * I have the platformsIds with comboIds done
    * I have the requestTraceId header with value starting with a "e2e-get-combo"
    * I set the token to the vendorId "<vendorId>"
    When I get combos through v4 endpoint
    Then The response code is "200" and the body leniently matches the json at file "response-get-combos-v4-simulation-v2-combos-with-free-goods" at folder "combo-service"

    # Simulation
    Given I have the payload at file "request-simulation-v2-combos-with-free-goods" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "response-simulation-v2-combos-with-free-goods" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             |
      | EC      | 70b33632-6bce-4eeb-95a2-ba0be90bf908 |