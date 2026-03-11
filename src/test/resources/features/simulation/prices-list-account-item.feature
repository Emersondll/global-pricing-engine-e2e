@ok
Feature: I want to be able to validate types of prices (price-list) and item-service integration in pricing-engine

  Scenario Outline:  Simulation of prices-list using item-service data

    # Generate Token
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
    * I set the token to the vendorId "<vendorId>"
    When I create account through v1 endpoint
    Then The response code is "202" and the body is blank

    # PUT Items
    Given I have the payload at file "<item-file-name>" at folder "item-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-item"
    * I set the token to the vendorId "<vendorId>"
    When I create items through v2 endpoint
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

    # GET Item
    Given I have the "vendorId" param with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-item"
    * I have the "vendorItemIds" param with value "<vendorItemIds>"
    * I set the token to the vendorId "<vendorId>"
    When I get items through v1 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<item-file-name>" at folder "item-service"

    # Simulation
    Given I have the payload at file "<simulation-file-name>" at folder "pricing-engine"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<simulation-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | price-list-file-name | account-file-name | item-file-name | simulation-file-name     | vendorItemIds                                                                                                                                                                         |
      | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-price-list-UOM    | br-account-UOM    | br-items       | br-simulation-price-list | VENDOR-SKU-BEESPR-14278-1,VENDOR-SKU-BEESPR-14278-2,VENDOR-SKU-BEESPR-14278-5,VENDOR-SKU-BEESPR-14277-2,VENDOR-SKU-BEESPR-14277-3,VENDOR-SKU-BEESPR-14277-4,VENDOR-SKU-BEESPR-14277-5 |
