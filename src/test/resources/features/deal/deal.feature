@ignore
Feature: I want to get the deals available for a customer

  Scenario Outline: Validate retrieve deals through pricing-engine endpoint

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

    # GET Deal through pricing-engine
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "timezone" header with value "<timezone>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-deal"
    * I have the "projection" param with value "<projection>"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<deal-response>" at folder "pricing-engine"

    Scenarios:
      | country | timezone             | vendorId                             | projection | price-file-name | deal-file-name | deal-response   |
      | AR      | America/Buenos_Aires | 29a9c869-e1b7-4011-9158-e2c53fed4d58 | PRICED     | ar-prices       | ar-deals       | ar-deals        |
      | CO      | America/Bogota       | 9c2e5bbf-6960-470f-9bf3-698b131f0522 | PLAIN      | co-prices       | co-deals       | co-deals        |
      | ZA      | Africa/Johannesburg  | dcc18843-a27c-46af-99b9-4b3dc15320aa | PLAIN      | za-prices       | za-deals       | za-plain-deals  |
      | ZA      | Africa/Johannesburg  | dcc18843-a27c-46af-99b9-4b3dc15320aa | PRICED     | za-prices       | za-deals       | za-priced-deals |