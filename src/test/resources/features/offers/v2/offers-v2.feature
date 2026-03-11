@ignore
Feature: I want to get the prices offers available for a customer from v2 endpoint

  Scenario Outline: Validate retrieve prices offers through pricing-engine v2 endpoint

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    Given I have vendorId "<vendorId_ambev>" for key "V-02"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic price list Id for key "1"
    * I have dynamic tax Id for key "1"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId>"
    * I generate the token to the vendorId "<vendorId>"
    * I generate the token to the vendorId "<vendorId_ambev>"

    # Generate Market Place Ids and token
    Given I have the "vendorId" header with value "<vendorId>"
    * I have dynamic market place ids

    # PUT Prices
    Given I have the payload at file "<price-file-name>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Items
    Given I have the payload at file "<item-file-name>" at folder "item-service"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-item-v2"
    When I create items through v2 endpoint
    Then The response code is "202" and the body is blank

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

    # GET Prices
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "<price-request-file-name>" at folder "price-service"
    * I have dynamic market place ids
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # GET Items
    Given I have the "vendorId" param with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-item"
    * I have the "vendorItemIds" param with value "<vendorItemIds>"
    * I set the token to the vendorId "<vendorId>"
    When I get items through v2 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<item-file-name>" at folder "item-service"

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

    # GET Prices Offers through pricing-engine
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-offers-v2"
    * I have the payload at file "<offers-request-file-name>" at folder "pricing-engine"
    * I have dynamic market place ids
    * I set the token to the vendorId "<vendorId>"
    When I get prices offers through pricing-engine v2 endpoint
    Then The response code is "200" and the body matches the json at file "<offers-response>" at folder "pricing-engine"

    Examples:
      | price-file-name                                                | country | timezone          | vendorId                             | offers-response                                      | price-request-file-name                               | offers-request-file-name                             | account-file-name    | item-file-name                                     | vendorItemIds                                         | vendorId_ambev                       |
      | br-offers-contractId                                           | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-offers-v2-contractId                              | br-v3-request-contractId                              | br-offers-v2-contractId                              | br-account-offers-v2 | br-items-v2                                        | VENDOR-SKU-BEESPR-15563-01,VENDOR-SKU-BEESPR-15563-02 | 7a51f522-c3e3-421b-89d8-290d8eb2eddd |
      | br-offers-deliveryCenterId                                     | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-offers-v2-deliveryCenterId                        | br-v3-request-deliveryCenterId                        | br-offers-v2-deliveryCenterId                        | br-account-offers-v2 | br-items-v2                                        | VENDOR-SKU-BEESPR-15563-01,VENDOR-SKU-BEESPR-15563-02 | 7a51f522-c3e3-421b-89d8-290d8eb2eddd |
      | br-prices-v3-tax-with-base-changes-offers-v2-contractId        | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-offers-v2-contractId-tax-with-base-changes        | br-v3-request-contractId-tax-with-base-changes        | br-offers-v2-contractId-tax-with-base-changes        | br-account-offers-v2 | br-items-v2-for-price-tax-with-base-changes        | VENDOR-SKU-BEESPR-20222-01                            | 7a51f522-c3e3-421b-89d8-290d8eb2eddd |
      | br-prices-v3-tax-increase-compare-per-uom-offers-v2-contractId | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-offers-v2-contractId-tax-increase-compare-per-uom | br-v3-request-contractId-tax-increase-compare-per-uom | br-offers-v2-contractId-tax-increase-compare-per-uom | br-account-offers-v2 | br-items-v2-for-price-tax-increase-compare-per-uom | VENDOR-SKU-BEESPR-20086-01                            | 7a51f522-c3e3-421b-89d8-290d8eb2eddd |