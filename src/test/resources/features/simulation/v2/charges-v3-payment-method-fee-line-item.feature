Feature: I want to be able to validate the Charges Payment Method fee in Line Item level

  Scenario Outline:  Simulation V2 with prices with taxes and charges and deals and charges v3

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId>"
    * I have dynamic price list Id for key "1"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"

     # PUT Prices to VENDOR 1 with prices type ACCOUNT through price-relay
    Given I have the payload at file "<price-relay-request>" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deal
    Given I have the payload at file "<deal-relay-request>" at folder "deal-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal-v2"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Charge
    Given I have the payload at file "<charge-relay-request>" at folder "charge-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    * I set the token to the vendorId "<vendorId>"
    When I create charges through v3 endpoint
    Then The response code is "202" and the body is blank

    # GET Prices
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "<price-api-request>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-api-response>" at folder "price-service"

    # POST to get deals
    Given I have the "country" header with value "<country>"
    * I set the token to the vendorId "<vendorId>"
    * I have the requestTraceId header with value starting with a "e2e-post-deal"
    * I have the payload at file "<deal-api-request>" at folder "deal-service"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-api-response>" at folder "deal-service"

    # GET Charge
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-charge"
    * I have the payload at file "<charge-api-request>" at folder "charge-service"
    * I set the token to the vendorId "<vendorId>"
    When I get charges through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<charge-api-response>" at folder "charge-service"

    # Simulation
    Given I have the payload at file "BR-simulation-v2-request-charges-payment-method-fee-scope-line-item" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "BR-simulation-v2-response-charges-payment-method-fee-scope-line-item" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             | price-relay-request                 | price-api-request                           | price-api-response                  | deal-relay-request    | deal-api-request                   | deal-api-response                   | charge-relay-request                                 | charge-api-request                                                 | charge-api-response                              | timezone          |
      | BR      | 7a51f522-c3e3-421b-89d8-290d8eb2eddd | br-prices-v3-with-taxes-and-charges | br-prices-v3-request-with-taxes-and-charges | br-prices-v3-with-taxes-and-charges | br-deals-v2-line-item | br-deals-v3-line-item-post-request | br-deals-v3-line-item-simulation-v2 | br-charges-v3-types-payment-method-fee-and-overprice | br-charges-v3-post-payment-method-fee-with-scope-line-item-request | br-charges-v3-payment-method-fee-scope-line-item | America/Sao_Paulo |
