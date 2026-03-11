@ok
Feature: I want to simulation in v2 endpoint combos and extra empties

  Scenario Outline: I want to simulation in v2 endpoint combos and extra empties

     # Generate Market Place Ids, token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId>"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"
    * I have dynamic tax Id for key "1"
    * I set the token to the vendorId "<vendorId>"

    # PUT Price
    Given I have the payload at file "create-price-v3-simulation-v2-combos-and-extra-empties-ddc" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I put the timezone header
    * I have the x-timestamp header with current time
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

     # GET Prices
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "request-get-price-v3-simulation-v2-combo-ddc" at folder "price-service"
    * I have dynamic market place ids
    * I put the timezone header
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "response-get-price-v3-simulation-v2-combo-ddc" at folder "price-service"

    # POST Combos for DDC
    Given I have the payload at file "create-combo-ddc-v3-simulation-v2" at folder "combo-service"
    * I have the "country" header with value "<country>"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the requestTraceId header with value starting with a "e2e-post-combo"
    * I put the timezone header
    * I set the token to the vendorId "<vendorId>"
    When I create combos with DDC through v3 endpoint
    Then The response code is "201" and the body is blank

    # GET Combos for DDC
    Given I have the "country" header with value "<country>"
    * I have combo delivery center platform Id for key "1" with comboId "ORIGINAL_COMBO_3926" and vendorId "<vendorId>"
    * I have the platformsIds with comboIds done
    * I have the requestTraceId header with value starting with a "e2e-get-combo"
    * I set the token to the vendorId "<vendorId>"
    When I get combos through v4 endpoint
    Then The response code is "200" and the body leniently matches the json at file "response-get-combo-v4-simulation-v2-combo-ddc" at folder "combo-service"

    # Simulation
    Given I have the payload at file "request-simulation-v2-combo-ddc" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I put the timezone header
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "<response>" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             | response                                                          |
      | HN      | 060ea43d-4a3d-4e47-b533-579e2f4e7b35 | HN-response-simulation-v2-combo-ddc-include-taxes-and-empties     |
      | PA      | c45d6e80-420c-4f57-ae77-2f5847b8ea29 | PA-response-simulation-v2-combo-ddc-not-include-taxes-and-empties |