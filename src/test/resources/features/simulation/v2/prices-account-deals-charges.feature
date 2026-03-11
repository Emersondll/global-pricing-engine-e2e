@ignore
Feature: I want to be able to validate types of prices (VENDOR, ACCOUNT, DELIVERY_CENTER, PRICE_LIST), deals (ACCOUNT), charges (ACCOUNT) and account-service integration in simulation/v2

  Scenario Outline:  Simulation V2 with prices using account-service data and charge v3 and deals v3

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    Given I have vendorId "<vendorId_2>" for key "V-02"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic price list Id for key "1"
    * I have dynamic tax Id for key "1"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId>"
    * I have dynamic contract Id for key "2" and vendorId "<vendorId_2>"
    * I have dynamic price list Id for key "2"
    * I have dynamic tax Id for key "2"
    * I have dynamic delivery Center Id for key "2" and vendorId "<vendorId_2>"
    * I generate the token to the vendorId "<vendorId>"
    * I generate the token to the vendorId "<vendorId_2>"

    # PUT Account for VENDOR 1
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "<account-file-name>" at folder "account-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-account"
    When I create account through v1 endpoint
    Then The response code is "202" and the body is blank

    # PUT Account for VENDOR 2
    Given I set the token to the vendorId "<vendorId_2>"
    * I have the payload at file "<account2-file-name>" at folder "account-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-account"
    When I create account through v1 endpoint
    Then The response code is "202" and the body is blank

    # PUT Prices to VENDOR 1 with prices type ACCOUNT
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "br-prices-v3-vendor1-type-account" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Prices to VENDOR 1 with prices type PRICE_LIST
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "br-prices-v3-vendor1-type-priceList" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Prices to VENDOR 1 with prices type DELIVERY_CENTER
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "br-prices-v3-vendor1-type-deliveryCenter" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Prices to VENDOR 1 with prices type VENDOR
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "br-prices-v3-vendor1-type-vendor" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Prices to VENDOR 2 with prices type ACCOUNT
    Given I set the token to the vendorId "<vendorId_2>"
    * I have the payload at file "br-prices-v3-vendor2-type-account" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Prices to VENDOR 2 with prices type DELIVERY_CENTER
    Given I set the token to the vendorId "<vendorId_2>"
    * I have the payload at file "br-prices-v3-vendor2-type-deliveryCenter" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Prices to VENDOR 2 with prices type VENDOR
    Given I set the token to the vendorId "<vendorId_2>"
    * I have the payload at file "br-prices-v3-vendor2-type-vendor" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deals to VENDOR 1 with prices type ACCOUNT
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "br-deals-vendor-1" at folder "deal-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal"
    When I create deals through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deals to VENDOR 2 with prices type ACCOUNT
    Given I set the token to the vendorId "<vendorId_2>"
    * I have the payload at file "br-deals-vendor-2" at folder "deal-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal"
    When I create deals through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Charges to VENDOR 1 with prices type ACCOUNT
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "br-charges-vendor-1" at folder "charge-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    When I create charges through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Charges to VENDOR 2 with prices type ACCOUNT
    Given I set the token to the vendorId "<vendorId_2>"
    * I have the payload at file "br-charges-vendor-2" at folder "charge-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    When I create charges through v2 endpoint
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

    # GET Prices to All Vendors
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "<price-request-file-name>" at folder "price-service"
    * I set the token to the vendorId "<vendorId_2>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # GET Deals to All Vendors
    Given I set the token to the vendorId "<vendorId_2>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-deal"
    * I have the payload at file "br-deals-v3-post-request" at folder "deal-service"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "br-deals-v3" at folder "deal-service"

    # GET Charges to All Vendors
    Given I set the token to the vendorId "<vendorId_2>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-charge"
    * I have the payload at file "br-charges-v3-post-request" at folder "charge-service"
    When I get charges through v3 endpoint
    Then The response code is "200" and the body matches the json at file "br-charges-v3" at folder "charge-service"

    # Simulation
    Given I have the payload at file "<simulation-file-name>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "<simulation-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | simulation-file-name | vendorId                             | vendorId_2                           | account-file-name        | account2-file-name               | price-request-file-name | price-file-name            |
      | BR      | America/Sao_Paulo | br-simulation-v2     | eafe490e-fddc-4b01-900a-d0dc45194ab6 | 7a51f522-c3e3-421b-89d8-290d8eb2eddd | br-account-simulation-v2 | br-account-simulation-v2-vendor2 | br-v3-post-request      | br-prices-v3-simulation-v2 |
