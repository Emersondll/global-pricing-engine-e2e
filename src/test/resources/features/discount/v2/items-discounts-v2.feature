@ignore
Feature: I want to see my promotions screen in marketplace

  Scenario Outline: Validate retrieve a price range through pricing-engine v2 endpoint (including prices with taxes.proportional true)

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have vendorId "<vendorId_ambev>" for key "V-02"
    * I have the "vendorId" header with value "<vendorId>"
    * I have dynamic market place ids
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"
    * I generate the token to the vendorId "<vendorId_ambev>"

    # PUT Contract for AMBEV. Note: only to create bees-account
    Given I set the token to the vendorId "<vendorId_ambev>"
    * I have the payload at file "<account-file-name>" at folder "account-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-account-vendor-1"
    When I create account through v1 endpoint
    Then The response code is "202" and the body is blank

    # PUT Account
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "<account-file-name>" at folder "account-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-account"
    When I create account through v1 endpoint
    Then The response code is "202" and the body is blank

    # PUT Price for contractId
    Given  I set the token to the vendorId "<vendorId>"
    * I have the payload at file "<price-file-name-contract-id>" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deal
    Given I have the payload at file "br-deals-v2-item-discounts-v2" at folder "deal-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Items
    Given I have the payload at file "<item-file-name>" at folder "item-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-item-v2"
    * I set the token to the vendorId "<vendorId>"
    When I create items through v2 endpoint
    Then The response code is "202" and the body is blank

    # GET Account
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-account"
    * I have the x-timestamp header with current time
    * I have the "projection" param with list values
      | priceListId      |
      | deliveryCenterId |
    * I have the "id" param with value dynamic contract id
    * I set the token to the vendorId "<vendorId>"
    When I get account through v2 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<account-file-name>" at folder "account-service"

    # GET Price
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "br-v3-request-item-discount-v2" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "br-prices-v3-item-discount-v2" at folder "price-service"

    # GET Deal
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "br-v3-request-deals" at folder "deal-service"
    * I have dynamic market place ids
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-file-name>" at folder "deal-service"

    # GET Items
    Given I have the "vendorId" param with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-item"
    * I have the "vendorItemIds" param with value "<vendorItemIds>"
    * I set the token to the vendorId "<vendorId>"
    When I get items through v2 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<item-file-name>" at folder "item-service"

    # GET Item Discount V2 (Price Range)
    Given I have the payload at file "<item-discount-file-name>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-item-discount-v2"
    * I set the token to the vendorId "<vendorId>"
    When I get the price range through pricing-engine v2 endpoint
    Then The response code is "200" and the body matches the json at file "<item-discount-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | account-file-name           | price-file-name-contract-id               | deal-file-name                | item-file-name                        | item-discount-file-name | vendorItemIds                                                                      | vendorId_ambev                       |
      | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-account-item-discount-v2 | br-prices-v3-item-discount-v2-contract-id | br-deals-v2-item-discounts-v2 | br-items-v2-item-discounts-v2-per-uom | br-item-discounts-v2    | VENDOR-SKU-BEESPR-16583-01, VENDOR-SKU-BEESPR-18965-02, VENDOR-SKU-BEESPR-18965-04 | 7a51f522-c3e3-421b-89d8-290d8eb2eddd |