@ok
Feature: I want to get the price offers from a ddc

  Scenario Outline: Validate retrieve prices offers through pricing-engine v2 endpoint

    # Generate Market Place Ids, token and taxId
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"
    * I have dynamic tax Id for key "1"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId>"
    * I have dynamic price list Id for key "1"

    # Generate Market Place Ids and token
    Given I have the "vendorId" header with value "<vendorId>"
    * I have dynamic market place ids

    # PUT Price
    Given I have the payload at file "<price-file-name>" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Account
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "<account-file-name>" at folder "account-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-account"
    When I create account through v1 endpoint
    Then The response code is "202" and the body is blank

    # POST to get the prices
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-price-v3"
    * I have the payload at file "<price-request-file-name>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

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

    Scenarios:
      | country | vendorId                             | timezone             | price-file-name                 | account-file-name | price-request-file-name                 | offers-request-file-name          | offers-response                    |
      | AR      | 29a9c869-e1b7-4011-9158-e2c53fed4d58 | America/Buenos_Aires | ar-price-offers-vendor          | ar-account-offers | ar-price-request-offers-vendor          | ar-request-offers-vendor          | ar-response-offers-vendor          |
      | AR      | 29a9c869-e1b7-4011-9158-e2c53fed4d58 | America/Buenos_Aires | ar-price-offers-delivery-center | ar-account-offers | ar-price-request-offers-delivery-center | ar-request-offers-delivery-center | ar-response-offers-delivery-center |