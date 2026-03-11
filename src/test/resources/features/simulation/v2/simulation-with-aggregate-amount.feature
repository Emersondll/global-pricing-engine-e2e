@ok
Feature: I want to be able to validate the simulation for zones with prices, charges, combos and with Aggregated Charges

  Scenario Outline:  Simulation V2 for zones with prices V3, charges v3, combos v4 from Data Ingestion and account-service integration

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I generate the token to the vendorId "<vendorId>"
    * I set the timezone to the "<country>"

    # PUT Prices to ACCOUNT
    Given I have the payload at file "<country>-prices-v3-charges-v3-simulation-v2" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3-account-id"
    * I put the timezone header
    * I have the x-timestamp header with current time
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Charges
    Given I have the payload at file "<country>-charges-v2-simulation-v2" at folder "charge-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    * I set the token to the vendorId "<vendorId>"
    When I create charges through v2 endpoint
    Then The response code is "202" and the body is blank

    # POST Combos with CHARGES
    Given I have the "country" header with value "<country>"
    * I have the payload at file "<country>-combos-v3-to-aggregated-amount" at folder "combo-service"
    * I have the requestTraceId header with value starting with a "e2e-post-combo"
    * I set the token to the vendorId "<vendorId>"
    When I create combos through v3 endpoint
    Then The response code is "202" and the body is blank

    # GET Prices
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "<country>-request-prices-v3-with-logistic-cost" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-prices-v3-with-logistic-cost" at folder "price-service"

    # GET Charges
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-charge"
    * I have the payload at file "<country>-request-charges-v3-simulation-v2-with-aggregated-amount" at folder "charge-service"
    * I set the token to the vendorId "<vendorId>"
    When I get charges through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-charges-v3-simulation-v2-with-aggregated-amount" at folder "charge-service"

    # GET Combos for Account
    Given I have the "country" header with value "<country>"
    * I have combo account platform Id for key "1" with comboId "VENDOR-COMBO-BEESPR-18369-1" and vendorId "<vendorId>"
    * I have the platformsIds with comboIds done
    * I have the requestTraceId header with value starting with a "e2e-get-combo"
    * I set the token to the vendorId "<vendorId>"
    When I get combos through v4 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<country>-combos-v4-to-aggregated-amount" at folder "combo-service"

    # Simulation with Aggregated Charges
    Given I have the payload at file "<country>-simulation-v2-aggregated-amount" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I put the timezone header
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-simulation-v2-aggregated-amount" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             |
      | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 |
