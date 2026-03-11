@ignore
Feature: I want to be able to validate the simulation for zones with prices, charges, combos and account-service integration in simulation/v2

  Scenario Outline:  Simulation V2 for zones with prices V3, charges v3, combos v4 from Data Ingestion and account-service integration

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic price list Id for key "1"
    * I have dynamic tax Id for key "1"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId>"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Account for VENDOR 1
    Given I have the payload at file "account-simulation-v2" at folder "account-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-account"
    * I set the token to the vendorId "<vendorId>"
    When I create account through v1 endpoint
    Then The response code is "202" and the body is blank

    # PUT Prices to VENDOR 1 with prices type ACCOUNT
    Given I have the payload at file "prices-v3-simulation-v2-account" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3-account-id"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I set the token to the vendorId "<vendorId>"
    When I create prices through data-ingestion
    Then The response code is "202" and the body is blank

    # PUT Prices to VENDOR 1 with prices type VENDOR
    Given I have the payload at file "prices-v3-simulation-v2-vendor" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3-vendor-id"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I set the token to the vendorId "<vendorId>"
    When I create prices through data-ingestion
    Then The response code is "202" and the body is blank

    # PUT Prices to VENDOR 1 with prices type DELIVERY_CENTER
    Given I have the payload at file "prices-v3-simulation-v2-ddc" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3-vendor-id"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I set the token to the vendorId "<vendorId>"
    When I create prices through data-ingestion
    Then The response code is "202" and the body is blank

    # PUT Prices to VENDOR 1 with prices type PRICE_LIST
    Given I have the payload at file "prices-v3-simulation-v2-priceList" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3-vendor-id"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I set the token to the vendorId "<vendorId>"
    When I create prices through data-ingestion
    Then The response code is "202" and the body is blank

    # PUT Charges of type VENDOR through data-ingestion
    Given I have the payload at file "charges-v3-simulation-v2-vendor" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I set the token to the vendorId "<vendorId>"
    When I create charges through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT Charges of type ACCOUNT through data-ingestion
    Given I have the payload at file "charges-v3-simulation-v2-account" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I set the token to the vendorId "<vendorId>"
    When I create charges through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT Charges of type DELIVERY_CENTER through data-ingestion
    Given I have the payload at file "charges-v3-simulation-v2-ddc" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I set the token to the vendorId "<vendorId>"
    When I create charges through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # POST Combos COMBOS_ACCOUNTS
    Given I have the payload at file "combos-v3-simulation-v2-account" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-combos"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I set the token to the vendorId "<vendorId>"
    When I create combos through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # GET Account
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-account"
    * I have the x-timestamp header with current time
    * I have the "projection" param with list values
      | priceListId      |
      | deliveryCenterId |
    * I have the "id" param with the list of all contractIds values
    * I set the token to the vendorId "<vendorId>"
    When I get account through v2 endpoint
    Then The response code is "200" and the body leniently matches the json at file "account-simulation-v2" at folder "account-service"

    # GET Prices
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "request-prices-simulation-v2" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "prices-v3-simulation-v2" at folder "price-service"

    # GET Charges
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-charge"
    * I have the payload at file "request-charges-v3-simulation-v2" at folder "charge-service"
    * I set the token to the vendorId "<vendorId>"
    When I get charges through v3 endpoint
    Then The response code is "200" and the body matches the json at file "charges-v3-simulation-v2" at folder "charge-service"

    # POST Combos COMBOS_DELIVERY_CENTERS
    Given I have the payload at file "combos-v3-simulation-v2-ddc" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-combos"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I set the token to the vendorId "<vendorId>"
    When I create combos through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # GET Combos for Account
    Given I have the "country" header with value "<country>"
    * I have combo account platform Id for key "1" with comboId "VENDOR-COMBO-BEESPR-17550-1" and vendorId "<vendorId>"
    * I have combo account platform Id for key "2" with comboId "VENDOR-COMBO-BEESPR-17550-2" and vendorId "<vendorId>"
    * I have combo account platform Id for key "3" with comboId "VENDOR-COMBO-BEESPR-17550-4" and vendorId "<vendorId>"
    * I have combo delivery center platform Id for key "1" with comboId "VENDOR-COMBO-BEESPR-17550-3" and vendorId "<vendorId>"
    * I have the platformsIds with comboIds done
    * I have the requestTraceId header with value starting with a "e2e-get-combo"
    * I set the token to the vendorId "<vendorId>"
    When I get combos through v4 endpoint
    Then The response code is "200" and the body leniently matches the json at file "combos-v4-simulation-v2" at folder "combo-service"

    # Simulation
    Given I have the payload at file "simulation-v2" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I put the timezone header
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "<simulation-response-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             | simulation-response-file-name       |
      # For BR zoned no apply charges on Combos object due the reverseCombo
      | BR      | eafe490e-fddc-4b01-900a-d0dc45194ab6 | BR-simulation-v2-combo-no-overprice |
       # For MX zone apply charges on Combos object
      | MX      | 7289d6e3-ea3b-4a23-904f-61e5b3e5c0b7 | MX-simulation-v2-combo-w-overprice  |