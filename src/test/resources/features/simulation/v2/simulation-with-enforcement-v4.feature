@ok
Feature: I want to be able to validate the enforcement limits v4 on simulation/v2 integration

  Scenario Outline:  Simulation V2 with prices and deals v3 to validate the enforcement limits v4

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId>"
    * I have dynamic price list Id for key "1"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Prices to VENDOR 1 with prices type ACCOUNT through price-relay
    Given I have the payload at file "<priceRequest>" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deals of type ACCOUNT through data-ingestion
    Given I have the payload at file "<dealRequest>" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-deals"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT Items
    Given I have the payload at file "<itemRequest>" at folder "item-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-item-v2"
    * I set the token to the vendorId "<vendorId>"
    When I create items through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Enforcemet V2 Limit to VENDOR 1 with balance = zero
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "<enforcementRequest>" at folder "enforcement-service"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-enforcement-vendor-1"
    When I create promotion limit through v2 endpoint
    Then The response code is "202" and the body is blank

    # GET Prices
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "<getPriceRequest>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<priceResponse>" at folder "price-service"

    # GET Deals through POST method
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-deals"
    * I have the payload at file "<getDealRequest>" at folder "deal-service"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<dealResponse>" at folder "deal-service"

    # GET Items
    Given I have the "vendorId" param with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-item"
    * I have the "vendorItemIds" param with value "<vendorItemIds>"
    * I set the token to the vendorId "<vendorId>"
    When I get items through v2 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<itemResponse>" at folder "item-service"

    # GET Enforcement V4 limit - part 1
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-enforcement-v4"
    * I have the "beesAccountId" param with value dynamic beesAccountId
    * I have the enforcement params with "1", "1", "<vendorId>", "PROMOTION" and "VD-BEESPR-17144-1"
    * I set the token to the vendorId "<vendorId>"
    When I get promotion limits through v4 endpoint
    Then The response code is "200" and the body leniently matches the json at file "PE-simulation-with-enforcement-limits-v4-part1-promotion" at folder "enforcement-service"

    # GET Enforcement V4 limit - part 2
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-enforcement-v4"
    * I have the "beesAccountId" param with value dynamic beesAccountId
    * I have the enforcement params with "1", "1", "<vendorId>", "FREEGOOD" and "<entityId>"
    * I set the token to the vendorId "<vendorId>"
    When I get promotion limits through v4 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<enforcementResponse>" at folder "enforcement-service"

    # Simulation
    Given I have the payload at file "<simulationRequest>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "<simulationResponse>" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             | priceRequest                                                         | dealRequest                                   | itemRequest                   | enforcementRequest                                          | getPriceRequest                                                     | priceResponse                                               | getDealRequest                                      | dealResponse                               | vendorItemIds     | itemResponse                 | entityId          | enforcementResponse                                         | simulationRequest                           | simulationResponse                          |
      # Enforcement not working for BR Zone changed to PE Zone
      #| BR      | 7a51f522-c3e3-421b-89d8-290d8eb2eddd |
      | PE      | badb25b3-f4be-4bf3-b635-910d6d62271e | PE-prices-v3-item-v2-deal-v3-enforcement-v4-simulation-v2-account    | PE-deals-v3-enforcement-v4-item-v2-account  | PE-items-v2-enforcement-v4      | PE-simulation-v2-deals-v3-BEESPR-17144-for-enforcement-v4   | PE-request-prices-v3-item-v2-deal-v3-enforcement-v4-simulation-v2   | PE-prices-v3-item-v2-deal-v3-enforcement-v4-simulation-v2   | PE-request-deals-v3-enforcement-v4-simulation-v2    | PE-deals-v3-enforcement-v4-simulation-v2   | VI-BEESPR-17144-1 | PE-items-v2-enforcement-v4   | VD-BEESPR-17144-2 | PE-simulation-with-enforcement-limits-v4-part2-freegoods    | PE-simulation-v2-deals-v3-enforcement-v4    | PE-simulation-v2-deals-v3-enforcement-v4    |
      | PE      | badb25b3-f4be-4bf3-b635-910d6d62271e | PE-prices-v3-item-v2-deal-v3-enforcement-v4-simulation-v2-account-2  | PE-deals-v3-enforcement-v4-item-v2-account-2  | PE-items-v2-enforcement-v4-2  | PE-simulation-v2-deals-v3-BEESPR-17144-for-enforcement-v4-2 | PE-request-prices-v3-item-v2-deal-v3-enforcement-v4-simulation-v2-2 | PE-prices-v3-item-v2-deal-v3-enforcement-v4-simulation-v2-2 | PE-request-deals-v3-enforcement-v4-simulation-v2-2  | PE-deals-v3-enforcement-v4-simulation-v2-2 | VI-BEESPR-22035-1 | PE-items-v2-enforcement-v4-2 | VD-BEESPR-22035-1 | PE-simulation-with-enforcement-limits-v4-part2-freegoods-2  | PE-simulation-v2-deals-v3-enforcement-v4-2  | PE-simulation-v2-deals-v3-enforcement-v4-2  |