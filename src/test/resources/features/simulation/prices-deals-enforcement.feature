@unstable
Feature:  I want to be able to validate types of prices, deals and enforcement limits in pricing-engine

  Scenario Outline: Simulation of prices, deals and enforcement limits
  These tests will verify if the enforcement service will return the expected values from promotion limits
  Outline 1 e 2:
  The enforcement service will return the limits for deal "VENDOR-DEAL-1" (enforced = true) and it will calculate the promotion values
  The enforcement service will return zero limits for deal "VENDOR-DEAL-3" (enforced = null) and it will not be calculated on the simulation
  The enforcement service will return zero limits for deal "VENDOR-DEAL-ENFORCED-FALSE-1" (enforced = false) and it will calculate in the simulation

  Outline 3:
  The enforcement will not return limits for deal "VENDOR-DEAL-ENFORCED-TRUE-1" (enforced = true) and will not add this deals in the simulation calculations
  The enforcement service will return the limits for deal "VENDOR-DEAL-2" (enforced = null) and it will calculate the promotion values (only for the outline 3)

    # Generate Token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Price
    Given I have the payload at file "<price-file-name>" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deal with enforced = true through data-ingestion
    Given I have the payload at file "<deal-data-ingestion-file-name>" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-deals"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT Enforcement limit
    Given I have the payload at file "<enforcement-file-name>" at folder "enforcement-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-enforcement"
    * I set the token to the vendorId "<vendorId>"
    When I create promotion limit through v2 endpoint
    Then The response code is "202" and the body is blank

    # GET Price
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-get-price"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # GET Deal
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-get-deal"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-response-file-name>" at folder "deal-service"

    # GET Enforcement limit
    Given I have the "vendorId" param with value "<vendorId>"
    * I have the "vendorAccountId" param with value dynamic account id
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-get-enforcement"
    * I set the token to the vendorId "<vendorId>"
    When I get promotion limits through v3 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<enforcement-file-name>" at folder "enforcement-service"

    # Simulation
    Given I have the payload at file "<simulation-file-name>" at folder "pricing-engine"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<simulation-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             | price-file-name | enforcement-file-name  | simulation-file-name                   | deal-data-ingestion-file-name | deal-response-file-name |
      | PE      | badb25b3-f4be-4bf3-b635-910d6d62271e | pe-prices       | pe-budget-limits       | pe-simulation-limits                   | pe-deals-v3-enforced          | pe-deals-with-enforced  |
      | PE      | badb25b3-f4be-4bf3-b635-910d6d62271e | pe-prices       | pe-availability-limits | pe-simulation-limits                   | pe-deals-v3-enforced          | pe-deals-with-enforced  |
      | PE      | badb25b3-f4be-4bf3-b635-910d6d62271e | pe-prices       | pe-quantity-limits     | pe-simulation-partial-freegoods-limits | pe-deals-v3-enforced          | pe-deals-with-enforced  |