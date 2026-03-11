@ignore
Feature:  I want to be able to validate types of prices and deals in pricing-engine

  Scenario Outline: Simulation of prices and deals

    # Generate Token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Price
    Given I have the payload at file "<price-file-name>" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v2 endpoint
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

    # GET Price
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-get-price"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # GET Deal
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-get-deal"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-file-name>" at folder "deal-service"

    # Simulation
    Given I have the payload at file "<simulation-file-name>" at folder "pricing-engine"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<simulation-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | timezone              | vendorId                             | price-file-name | deal-file-name | simulation-file-name |
      # AR: Price (Simple Tax, Compound Tax, Conditional Tax, Valid From) + Deal (Payment Method Condition, Multiple Line Item Condition, Multiple Line Item Discount, Line Item Scaled Discount, Accumulation)
      | AR      | America/Buenos_Aires  | 29a9c869-e1b7-4011-9158-e2c53fed4d58 | ar-prices       | ar-deals       | ar-simulation        |
      # DO: Price (Simple Tax, Compound Tax, Deposit) + Deal (Line Item Condition, Deal Line Item Discount, Deal Scaled Line Item)
      | DO      | America/Santo_Domingo | 9c2e5bbf-6960-470f-9bf3-698b131f0522 | do-prices       | do-deals       | do-simulation        |
      # ZA: Price (Simple Tax, Deposit) + Deal (Line Item Discount, Pallet Discount, Order Total Discount, Line Item Scaled Discount, Best Per Level Strategy)
      | ZA      | Africa/Johannesburg   | dcc18843-a27c-46af-99b9-4b3dc15320aa | za-prices       | za-deals       | za-simulation        |