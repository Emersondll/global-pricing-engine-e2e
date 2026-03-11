@ok
Feature: I want to be able to validate the Charges Payment Method RECEIVABLES_AS_CREDIT in Simulation

  Scenario Outline:  Simulation V2 with price, deal and charges "PAYMENT_METHOD_FEE" (RECEIVABLES_AS_CREDIT / FIXED) + "DELIVERY_DATE_FEE"

    # Generate Market Place Ids, token and taxId
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I generate the token to the vendorId "<vendorId>"
    * I set the timezone to the "<country>"

    # PUT Prices
    Given  I have the payload at file "<price-relay-request>" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3-"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
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

    # PUT Deals
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "<deal-relay-request>" at folder "deal-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal-v3-vendor-1"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through v3 endpoint
    Then The response code is "202" and the body is blank

    # POST Prices
    Given I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-post-price-v3-all-vendors"
    * I have the payload at file "<price-api-request>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-api-response>" at folder "price-service"

    # POST Charge
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-charge"
    * I have the payload at file "<charge-api-request>" at folder "charge-service"
    * I set the token to the vendorId "<vendorId>"
    When I get charges through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<charge-api-response>" at folder "charge-service"

    # POST Deals
    Given I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-post-deal-all-vendors"
    * I have the payload at file "<deal-api-request>" at folder "deal-service"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-api-response>" at folder "deal-service"

    # Simulation
    Given I have the payload at file "<simulation-request>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I put the timezone header
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "<simulation-response>" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             | timezone          | price-relay-request                         | charge-relay-request                          | deal-relay-request                                    | price-api-request                                   | price-api-response                          | charge-api-request                                    | charge-api-response                           | deal-api-request                                           | deal-api-response                                     | simulation-request                               | simulation-response                              |
      | BR      | 7a51f522-c3e3-421b-89d8-290d8eb2eddd | America/Sao_Paulo | br-price-v3-price-tax-receivables-as-credit | br-charges-v3-price-tax-receivables-as-credit | br-deals-v3-line-item-price-tax-receivables-as-credit | br-price-v3-request-price-tax-receivables-as-credit | br-price-v3-price-tax-receivables-as-credit | br-request-charges-v3-price-tax-receivables-as-credit | br-charges-v3-price-tax-receivables-as-credit | br-request-deals-line-item-price-tax-receivables-as-credit | br-deals-v3-line-item-price-tax-receivables-as-credit | br-simulation-v2-price-tax-receivables-as-credit | br-simulation-v2-price-tax-receivables-as-credit |