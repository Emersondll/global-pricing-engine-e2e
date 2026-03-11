@ok
Feature:  I want to be able to validate types of prices and deals v3 by data ingestion in pricing-engine

  Scenario Outline: Simulation of prices and deals v3 by data ingestion

    # Generate Token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I generate the token to the vendorId "<vendorId>"
    * I set the timezone to the "<country>"

    # PUT Price
    Given I have the payload at file "<price-file-name>" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the x-timestamp header with current time
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-price"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deals of type ACCOUNT through data-ingestion
    Given I have the payload at file "<deal-file-name>" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-deals-di"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # GET Price
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-get-price"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # GET Deal
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-get-deal"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-file-name>" at folder "deal-service"

    # Simulation
    Given I have the payload at file "<simulation-file-name>" at folder "pricing-engine"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<simulation-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             | price-file-name  | deal-file-name  | simulation-file-name |
      | BR      | eafe490e-fddc-4b01-900a-d0dc45194ab6 | BR-prices-coupon | BR-deals-coupon | BR-simulation-coupon |
      | EC      | 6b1c3a4d-5385-49fc-937c-eff4282b4388 | EC-prices-coupon | EC-deals-coupon | EC-simulation-coupon |