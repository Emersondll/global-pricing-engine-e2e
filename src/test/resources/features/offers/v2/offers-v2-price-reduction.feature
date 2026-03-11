@ok

Feature: I want to get the prices offers with deals containing price reduction for a customer from v2 endpoint

  Scenario Outline: Validate retrieve prices offers with deals containing price reduction of different levels by pricing-engine v2 endpoint

    # Generate Market Place Ids, token and taxId
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Price
    Given  I have the payload at file "<price-file-name>" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deals
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "<deal-file-name>" at folder "deal-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal-v3-vendor"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through v3 endpoint
    Then The response code is "202" and the body is blank

    # POST to get the prices
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-price-v3"
    * I have the payload at file "br-request-prices-v3-offers-v2-with-price-reduction" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # POST to get the deals
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-deal-v3"
    * I have the payload at file "br-request-deals-v3-offers-v2-with-price-reduction" at folder "deal-service"
    * I have dynamic market place ids
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-file-name>" at folder "deal-service"

    # GET Prices Offers through pricing-engine
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-offers-v2"
    * I have the payload at file "<offers-file-name>" at folder "pricing-engine"
    * I have dynamic market place ids
    * I set the token to the vendorId "<vendorId>"
    When I get prices offers through pricing-engine v2 endpoint
    Then The response code is "200" and the body matches the json at file "<offers-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | price-file-name                             | deal-file-name                           | offers-file-name                   |
      | BR      | America/Sao_Paulo | d8e9fbc3-0678-4778-beb7-74165906d3fa | br-prices-v3-offers-v2-with-price-reduction | br-deals-v3-price-reduction-level-offers | br-offers-v2-price-reduction-level |