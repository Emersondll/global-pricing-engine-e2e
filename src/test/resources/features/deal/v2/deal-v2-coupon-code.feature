@ok
Feature: I want to be able to validate the deals fields: couponCode and hiddenOnBrowse on simulation/v2 integration

  Scenario Outline:  Simulation V2 with prices and deals v3 to validate the new fields: couponCode and hiddenOnBrowse

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic contract Id for key "2" and vendorId "<vendorId>"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Prices to VENDOR 1 with prices type ACCOUNT through price-relay
    Given I have the payload at file "<country>-prices-v3-item-v2-deal-v3-coupon-deals-v2-account" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Prices to VENDOR 2 with prices type ACCOUNT through price-relay
    Given I have the payload at file "<country>-prices-v3-item-v2-deal-v3-coupon-deals-v2-account-2" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deals of type ACCOUNT through data-ingestion
    Given I have the payload at file "<deals-data-ingestion-request>" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-deals"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # GET Prices
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "<country>-request-prices-v3-item-v2-deal-v3-coupon-deals-v2" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-prices-v3-item-v2-deal-v3-coupon-deals-v2" at folder "price-service"

    # GET Deals through POST method
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-deals"
    * I have the payload at file "<pricing-engine-deals-v3-request>" at folder "pricing-engine"
    * I have the "types" param with value "<types>"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<pricing-engine-deals-v2-response-file>" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             | pricing-engine-deals-v3-request                   | pricing-engine-deals-v2-response-file              | deals-data-ingestion-request                 | types  |
      | BR      | d8e9fbc3-0678-4778-beb7-74165906d3fa | deals-v3-request-types-coupon-with-coupon-code    | deals-v2-response-types-coupon-with-coupon-code    | BR-deals-v3-types-coupon-with-coupon-code    | COUPON |
      | BR      | d8e9fbc3-0678-4778-beb7-74165906d3fa | deals-v3-request-types-null-with-coupon-code      | deals-v2-response-types-null-with-coupon-code      | BR-deals-v3-types-null-with-coupon-code      |        |