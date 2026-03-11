@ignore
Feature: I want to get the deals v2 created in the data ingestion applying enforcement

  Scenario Outline: Validate retrieving deals v2 created at data ingestion and applying enforcements according field enforced

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic price list Id for key "1"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Prices for Account
    Given I have the payload at file "br-prices-v3-deals-v2-enforcement-data-ingestion" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT account deal through data ingestion
    Given I have the payload at file "<deal-input-file>" at folder "data-ingestion"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-account-deal-data-ingestion"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT Enforcemet V2 Limit
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "br-quantity-limits-deal-v2-enforcement-data-ingestion" at folder "enforcement-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-enforcement"
    When I create promotion limit through v2 endpoint
    Then The response code is "202" and the body is blank

    # POST to get the prices
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "br-prices-v3-deals-v2-enforcement-data-ingestion-request" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "br-prices-v3-deals-v2-enforcement-data-ingestion-response" at folder "price-service"

    # POST to get deals
    Given I have the "country" header with value "<country>"
    * I set the token to the vendorId "<vendorId>"
    * I have the requestTraceId header with value starting with a "e2e-post-deal-all"
    * I have the payload at file "br-deals-v3-post-request-enforcement-data-ingestion" at folder "deal-service"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-response-post-file>" at folder "deal-service"

    # GET Enforcement V4 limit
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-enforcement-v4"
    * I have the "beesAccountId" param with value dynamic beesAccountId
    * I have the enforcement params with "1", "1", "<vendorId>", "PROMOTION" and "VENDOR-PROMO-1"
    * I have the enforcement params with "1", "2", "<vendorId>", "PROMOTION" and "VENDOR-PROMO-2"
    * I set the token to the vendorId "<vendorId>"
    When I get promotion limits through v4 endpoint
    Then The response code is "200" and the body leniently matches the json at file "br-limits-deal-v2-enforcement-data-ingestion" at folder "enforcement-service"

    # GET Deal V2 through pricing-engine
    Given I have the payload at file "br-deal-v2-enforcement-data-ingestion" at folder "pricing-engine"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-pricing-engine-deals-v2"
    * I have the "timezone" header with value "<timezone>"
    When I get deals v2 through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<pricing-engine-deal-file>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | deal-input-file                                       | deal-response-post-file                               | pricing-engine-deal-file                             |
      | PE      | America/Sao_Paulo | badb25b3-f4be-4bf3-b635-910d6d62271e | br-deals-v3-enforcement-data-ingestion                | br-deals-v3-enforcement-data-ingestion                | br-deal-v2-enforcement-data-ingestion                |
      | PE      | America/Sao_Paulo | badb25b3-f4be-4bf3-b635-910d6d62271e | br-deals-v3-enforcement-data-ingestion-enforced-false | br-deals-v3-enforcement-data-ingestion-enforced-false | br-deal-v2-enforcement-data-ingestion-enforced-false |
