@ignore
Feature: I want to get the deals v2 available for a customer

  Scenario Outline: Validate retrieve deals v2 through pricing-engine endpoint (including prices with taxes.proportional true)

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    Given I have vendorId "<vendorId_ambev>" for key "V-02"
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

    # PUT Deal
    Given I have the payload at file "<deal-v3-create>" at folder "deal-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through v3 endpoint
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
    * I have the "timezone" header with value "<timezone>"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # GET Deal V2 through pricing-engine
    Given I have the payload at file "<deal-v2-file-name>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-pricing-engine-deals-v2"
    * I have the "timezone" header with value "<timezone>"
    * I set the token to the vendorId "<vendorId>"
    When I get deals v2 through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<deal-v2-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | price-file-name               | price-request-file-name      | account-file-name   | deal-v3-create         | deal-v2-file-name            | vendorId_ambev                       |
      | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-prices-v3-get-deals-by-ddc | br-v3-deals-v2-request-ambev | br-account-deals-v2 | br-create-deals-v3-ddc | br-deals-v2-get-deals-by-ddc | 7a51f522-c3e3-421b-89d8-290d8eb2eddd |
