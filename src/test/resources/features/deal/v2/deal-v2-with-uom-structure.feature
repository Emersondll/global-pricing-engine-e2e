@ignore
Feature: I want to get the deals v2 with uom structure informing valid contractId, valid deliveryDate and valid items

  Scenario Outline: Validate all types of deals v2 through pricing-engine endpoint (including prices with taxes.proportional true)

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have vendorId "<vendorId_ambev>" for key "V-02"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic price list Id for key "1"
    * I have dynamic tax Id for key "1"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId>"
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

    # PUT Prices
    Given I have the payload at file "<price-file-name>" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Items
    Given I have the payload at file "<item-file-name>" at folder "item-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-item-v2"
    * I set the token to the vendorId "<vendorId>"
    When I create items through v2 endpoint
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

    # GET Account
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-account"
    * I have the x-timestamp header with current time
    * I have the "projection" param with list values
      | priceListId      |
      | deliveryCenterId |
    * I have the "id" param with the list of all contractIds values
    * I set the token to the vendorId "<vendorId>"
    When I get account through v2 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<account-file-name>" at folder "account-service"

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

    # GET Deal V2 through pricing-engine validating the data by item filtering from BEESPR-14799
    Given I have the payload at file "<deal-request-file-name>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-pricing-engine-deals-v2"
    * I have the "timezone" header with value "<timezone>"
    * I set the token to the vendorId "<vendorId>"
    When I get deals v2 through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<deal-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | price-file-name                         | price-request-file-name                  | account-file-name                     | deal-file-name                | deal-request-file-name                | item-file-name                         | vendorItemIds                                                                                                                                     | vendorId_ambev                       |
      | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-prices-v3-deals-v2-for-uom-structure | br-v3-deals-v2-request-for-uom-structure | br-account-deals-v2-for-uom-structure | br-deals-v2-for-uom-structure | br-deals-v2-request-for-uom-structure | br-items-v2-deals-v2-for-uom-structure | VENDOR-1-BEESPR-T4598, VENDOR-1-BEESPR-T4598-2, VENDOR-1-BEESPR-T4598-3,VENDOR-1-BEESPR-18696-1, VENDOR-1-BEESPR-18696-2, VENDOR-1-BEESPR-18696-3 | 7a51f522-c3e3-421b-89d8-290d8eb2eddd |