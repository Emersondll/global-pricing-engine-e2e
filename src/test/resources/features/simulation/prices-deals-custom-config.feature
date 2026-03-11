@ok
Feature: I want to be able to simulation in pricing-engine/v1, with custom vendor configuration

  Scenario Outline: Simulation of prices and deals, with vendor with custom configuration
  - Scenario 01: Vendor BRF
  -- Configurations:
  --- lineItemTotalRoundingStrategy: HALF_UP
  --- isAllowedCloseRanges: false
  - Scenario 02: Vendor Mercasid
  -- Configurations:
  --- freeGoodsDiscountChoiceStrategy: ALL
  --- lineItemDiscountChoiceStrategy: ALL
  --- orderDiscountChoiceStrategy: ALL
  --- isAllowedCloseRanges: false

    # Generate Token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Price
    Given I have the payload at file "<price-relay-request>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deal
    Given I have the payload at file "<deal-relay-request>" at folder "deal-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through v2 endpoint
    Then The response code is "202" and the body is blank

    # GET Price
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-get-price"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<price-api-response>" at folder "price-service"

    # GET Deal
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-get-deal"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-api-response>" at folder "deal-service"

    # Simulation
    Given I have the payload at file "<simulation-request>" at folder "pricing-engine"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<simulation-response>" at folder "pricing-engine"

    Scenarios:
      | country | timezone              | vendorId                             | price-relay-request                                   | price-api-response                                      | deal-relay-request                                   | deal-api-response                                      | simulation-request                          | simulation-response                          |
      # Vendor BRF
      | BR      | America/Sao_Paulo     | 3c5eece4-ac37-44e3-a95e-a264802a7dfe | br-create-prices-v2-for-simulation-with-custom-config | br-prices-v2-response-for-simulation-with-custom-config | br-create-deals-v2-for-simulation-with-custom-config | br-deals-v2-response-for-simulation-with-custom-config | br-simulation-v1-request-with-custom-config | br-simulation-v1-response-with-custom-config |
      # Vendor Mercasid
      | DO      | America/Santo_Domingo | 63907b3e-3fb7-4f4c-b514-597c15c83042 | do-create-prices-v2-for-simulation-with-custom-config | do-prices-v2-response-for-simulation-with-custom-config | do-create-deals-v2-for-simulation-with-custom-config | do-deals-v2-response-for-simulation-with-custom-config | do-simulation-v1-request-with-custom-config | do-simulation-v1-response-with-custom-config |