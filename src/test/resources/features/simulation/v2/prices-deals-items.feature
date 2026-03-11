@ok
Feature: I want to be able to validate the deals fields: couponCode and hiddenOnBrowse on simulation/v2 integration

  Scenario Outline:  Simulation V2 with prices and deals v3 to validate the new fields: couponCode and hiddenOnBrowse

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId>"
    * I have dynamic price list Id for key "1"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"

     # PUT Prices to VENDOR 1 with prices type ACCOUNT through price-relay
    Given I have the payload at file "<country>-prices-v3-item-v2-deal-v3-coupon-simulation-v2-account" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # GET Prices
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "<country>-request-prices-v3-item-v2-deal-v3-coupon-simulation-v2" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-prices-v3-item-v2-deal-v3-coupon-simulation-v2" at folder "price-service"

    # PUT Deals of type ACCOUNT through data-ingestion
    Given I have the payload at file "<country>-deals-v3-coupon-item-v2-account" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-deals"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT Charge
    Given I have the payload at file "<charge-file-name>" at folder "charge-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    * I set the token to the vendorId "<vendorId>"
    When I create charges through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Items
    Given I have the payload at file "<country>-items-v2-coupon" at folder "item-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-item-v2"
    * I set the token to the vendorId "<vendorId>"
    When I create items through v2 endpoint
    Then The response code is "202" and the body is blank

    # GET Deals through POST method
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-deals"
    * I have the payload at file "<country>-request-deals-v3-coupon-simulation-v2" at folder "deal-service"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-deals-v3-coupon-simulation-v2" at folder "deal-service"

    # GET Charge
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-charge"
    * I have the payload at file "charges-v3-post-request" at folder "charge-service"
    * I set the token to the vendorId "<vendorId>"
    When I get charges through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<charge-file-name>" at folder "charge-service"

    # GET Items
    Given I have the "vendorId" param with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-item"
    * I have the "vendorItemIds" param with value "<vendorItemIds>"
    * I set the token to the vendorId "<vendorId>"
    When I get items through v2 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<country>-items-v2-coupon" at folder "item-service"

    # Simulation
    Given I have the payload at file "<country>-simulation-v2-deals-v3-coupon" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-simulation-v2-deals-v3-coupon" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             | vendorItemIds                                                                                                                | charge-file-name        | timezone          |
      | BR      | 7a51f522-c3e3-421b-89d8-290d8eb2eddd | VENDOR-BEESPR-17680-V2-1,VENDOR-BEESPR-17680-V2-2,VENDOR-BEESPR-17680-V2-3,VENDOR-BEESPR-17680-V2-4,VENDOR-BEESPR-17680-V2-5 | br-charges-prices-deals | America/Sao_Paulo |
      | EC      | 6b1c3a4d-5385-49fc-937c-eff4282b4388 | VENDOR-BEESPR-17680-V2-1,VENDOR-BEESPR-17680-V2-2,VENDOR-BEESPR-17680-V2-3,VENDOR-BEESPR-17680-V2-4,VENDOR-BEESPR-17680-V2-5 | ec-charges-prices-deals | America/Guayaquil |