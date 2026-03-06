@unstable
Feature: I want to get the deals with promotion limits available for a customer

  Scenario Outline: Validate retrieve deals with promotion limits through pricing-engine endpoint
  In these tests we are going to verify that enforcement is going to retrieve two deals.
  The deal "VENDOR-DEAL-1" should have limits and it will be returned in the response
  the deal "VENDOR-DEAL-3" should have no limits and it will be removed from response

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

    # PUT Deal
    Given I have the payload at file "<deal-file-name>" at folder "deal-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Enforcement limit
    Given I have the payload at file "<enforcement-file-name>" at folder "enforcement-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-enforcement"
    * I set the token to the vendorId "<vendorId>"
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
    Then The response code is "200" and the body matches the json at file "<deal-file-name>" at folder "deal-service"

    # GET Enforcement limit
    Given I have the "vendorId" param with value "<vendorId>"
    * I have the "timezone" header with value "<timezone>"
    * I have the "vendorAccountId" param with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-enforcement"
    * I set the token to the vendorId "<vendorId>"
    When I get promotion limits through v3 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<enforcement-file-name>" at folder "enforcement-service"

    # GET Deal through pricing-engine
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "timezone" header with value "<timezone>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-deal"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<deal-response>" at folder "pricing-engine"

    Scenarios:
      | country | timezone     | price-file-name | vendorId                             | deal-file-name        | enforcement-file-name  | deal-response         |
      | PE      | America/Lima | pe-prices       | badb25b3-f4be-4bf3-b635-910d6d62271e | pe-deals-with-limits  | pe-budget-limits       | pe-deals-with-limits  |
      | PE      | America/Lima | pe-prices       | badb25b3-f4be-4bf3-b635-910d6d62271e | pe-deals-with-limits2 | pe-availability-limits | pe-deals-with-limits2 |
      | PE      | America/Lima | pe-prices       | badb25b3-f4be-4bf3-b635-910d6d62271e | pe-deals-with-limits3 | pe-quantity-limits     | pe-deals-with-limits3 |