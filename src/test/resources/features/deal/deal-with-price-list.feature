@ignore
Feature: I want to get the deals available for a customer with price list

  Scenario Outline: Validate retrieve deals through pricing-engine endpoint with price list

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Price List
    Given I have the payload at file "<price-list-file-name>" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Account
    Given I have the payload at file "<account-file-name>" at folder "account-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-account"
    * I have the x-timestamp header with current time
    * I set the token to the vendorId "<vendorId>"
    When I create account through v1 endpoint
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

    # GET Price List
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "priceListId" header with value dynamic price list id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<price-list-file-name>" at folder "price-service"

    # GET Account
    Given I have the "vendorId" param with value "<vendorId>"
    * I have the "vendorAccountId" param with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-account"
    * I have the "projection" param with value "PRICE_LIST_ID"
    * I set the token to the vendorId "<vendorId>"
    When I get account through v1 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<account-file-name>" at folder "account-service"

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
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-deal"
    * I have the "projection" param with value "<projection>"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<deal-response>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | projection | vendorId                             | price-list-file-name | account-file-name | deal-file-name | deal-response   |
      | BR      | America/Sao_Paulo | PRICED     | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-price-list        | br-account        | br-deals       | br-priced-deals |
