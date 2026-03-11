@ignore
Feature: I want to get the combos available for a customer on simulation v2 using relay service

  Scenario Outline: Validate get combos through simulation v2 from pricing-engine endpoint using relay service

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Price
    Given I have the payload at file "<country>-prices-v3-simulation-v2-combos-v4-charge-from-prices" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v2 endpoint
    Then The response code is "202" and the body is blank

    # POST Combos COMBOS_ACCOUNTS
    Given I have the payload at file "<country>-combos-v4" at folder "combo-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-combo"
    * I have the "vendorId" header with value "<vendorId>"
    * I put the timezone header
    * I set the token to the vendorId "<vendorId>"
    When I create combos through v3 endpoint
    Then The response code is "202" and the body is blank

    # GET Prices
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "<country>-request-prices-v3-simulation-v2-combos-v4-charge-from-prices" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-prices-v3-simulation-v2-combos-v4-charge-from-prices" at folder "price-service"

    # GET Combos for Account
    Given I have the "country" header with value "<country>"
    * I have combo account platform Id for key "1" with comboId "VENDOR-COMBO-BEESPR-18752-1" and vendorId "<vendorId>"
    * I have combo account platform Id for key "2" with comboId "VENDOR-COMBO-BEESPR-18752-2" and vendorId "<vendorId>"
    * I have the platformsIds with comboIds done
    * I have the requestTraceId header with value starting with a "e2e-get-combo"
    * I set the token to the vendorId "<vendorId>"
    When I get combos through v4 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<country>-combos-v4" at folder "combo-service"

    # Simulation
    Given I have the payload at file "<country>-simulation-v2-combos-v4-charge-from-prices" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-simulation-v2-combos-v4-charge-from-prices" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             |
      | BR      | eafe490e-fddc-4b01-900a-d0dc45194ab6 |
      | MX      | 7289d6e3-ea3b-4a23-904f-61e5b3e5c0b7 |