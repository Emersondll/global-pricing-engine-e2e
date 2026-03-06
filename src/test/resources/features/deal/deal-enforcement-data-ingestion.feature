@unstable
Feature: I want to get the deals v1 created in the data ingestion applying enforcement

  Scenario Outline: Validate retrieving deals v1 created at data ingestion and applying enforcements according field enforced

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Price
    Given I have the payload at file "<price-file-name>" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT deal through data ingestion
    Given I have the payload at file "<deal-input-file>" at folder "data-ingestion"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-account-deal-data-ingestion"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT Enforcemet V2 Limit
    Given  I set the token to the vendorId "<vendorId>"
    * I have the payload at file "pe-budget-limits" at folder "enforcement-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-enforcement"
    When I create promotion limit through v2 endpoint
    Then The response code is "202" and the body is blank

    # GET Price
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "timezone" header with value "<timezone>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # GET Deal
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "timezone" header with value "<timezone>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-deal"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-response-post-file>" at folder "deal-service"

    # GET Enforcement limit
    Given I have the "vendorId" param with value "<vendorId>"
    * I have the "timezone" header with value "<timezone>"
    * I have the "vendorAccountId" param with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-enforcement-v3"
    * I set the token to the vendorId "<vendorId>"
    When I get promotion limits through v3 endpoint
    Then The response code is "200" and the body leniently matches the json at file "pe-budget-limits" at folder "enforcement-service"

    # GET Deal V1 through pricing-engine
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "timezone" header with value "<timezone>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-deal-by-pricing-engine-v1"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through pricing-engine endpoint
    Then The response code is "<status-response>" and the body matches the json at file "<pricing-engine-deal-file>" at folder "pricing-engine"

    Scenarios:
      | country | timezone     | vendorId                             | price-file-name | deal-input-file                                       | deal-response-post-file                               | pricing-engine-deal-file                          | status-response |
      | PE      | America/Lima | badb25b3-f4be-4bf3-b635-910d6d62271e | pe-prices       | pe-deals-v3-enforcement-data-ingestion                | pe-deals-v3-enforcement-data-ingestion                | pe-deal-enforcement-data-ingestion                | 404             |
      | PE      | America/Lima | badb25b3-f4be-4bf3-b635-910d6d62271e | pe-prices       | pe-deals-v3-enforcement-data-ingestion-enforced-false | pe-deals-v3-enforcement-data-ingestion-enforced-false | pe-deal-enforcement-data-ingestion-enforced-false | 200             |
