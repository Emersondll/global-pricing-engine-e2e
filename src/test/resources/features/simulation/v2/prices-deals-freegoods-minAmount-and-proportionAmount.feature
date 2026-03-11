@ok
Feature: I want to be able to validate the new fields for deals minAmount and proportionAmount

  Scenario Outline:  Simulation V2 with prices and deals v3 to validate minAmount and proportionAmount for output freeGoods

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId>"
    * I have dynamic price list Id for key "1"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Prices to VENDOR 1 with prices type ACCOUNT through price-relay
    Given I have the payload at file "<country>-<createPrices>" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deals
    Given I have the payload at file "<country>-<createDeals>" at folder "deal-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through v2 endpoint
    Then The response code is "202" and the body is blank

    # GET Prices
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "<country>-<requestPrices>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-<responsePrices>" at folder "price-service"

    # GET Deals through POST method
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-deals"
    * I have the payload at file "<country>-<requestDeals>" at folder "deal-service"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-<responseDeals>" at folder "deal-service"

    # Simulation
    Given I have the payload at file "<country>-<requestSimulation>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<country>-<responseSimulation>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | createPrices                                    | createDeals                                    | requestPrices                                    | requestDeals                                    | responsePrices                                    | responseDeals                                    | requestSimulation                                       | responseSimulation                                    |
      | BR      | America/Sao_Paulo | 7a51f522-c3e3-421b-89d8-290d8eb2eddd | create-prices-v3-minimumAmount-proportionAmount | create-deals-v2-minimumAmount-proportionAmount | request-prices-v3-minimumAmount-proportionAmount | request-deals-v3-minimumAmount-proportionAmount | response-prices-v3-minimumAmount-proportionAmount | response-deals-v3-minimumAmount-proportionAmount | request-simulation-deals-minimumAmount-proportionAmount | response-simulation-v2-minimumAmount-proportionAmount |