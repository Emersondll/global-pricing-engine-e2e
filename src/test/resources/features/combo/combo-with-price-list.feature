@ok
Feature: I want to get the combos available for a customer with price list

  Scenario Outline: Validate get combos through pricing-engine endpoint with price list

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"

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
    * I set the token to the vendorId "<vendorId>"
    When I create account through v1 endpoint
    Then The response code is "202" and the body is blank

    # POST Combos
    Given I have the payload at file "<combo-file-name>" at folder "combo-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-combo"
    * I have the "vendorId" header with value "<vendorId>"
    * I set the token to the vendorId "<vendorId>"
    When I create combos through v3 endpoint
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
    * I have the x-timestamp header with current time
    * I have the "projection" param with value "PRICE_LIST_ID"
    * I set the token to the vendorId "<vendorId>"
    When I get account through v1 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<account-file-name>" at folder "account-service"

    # GET Combos
    Given I have the "vendorAccountId" param with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-combo"
    * I set the token to the vendorId "<vendorId>"
    When I get combos through v3 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<combo-file-name>" at folder "combo-service"

    # GET Combo through pricing-engine
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-combo"
    * I set the token to the vendorId "<vendorId>"
    When I get combos through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<combo-response>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | price-list-file-name | account-file-name | combo-file-name | combo-response |
      | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-price-list-combos | br-account-combos | br-combos       | br-combos      |