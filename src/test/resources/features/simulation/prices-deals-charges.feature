@ignore
Feature:  I want to be able to validate types of prices, deals and charges in pricing-engine

  Scenario Outline: Simulation of prices, deals and charges

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

    # PUT Charge
    Given I have the payload at file "<charge-file-name>" at folder "charge-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    * I set the token to the vendorId "<vendorId>"
    When I create charges through v2 endpoint
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

    # GET Charge
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-get-charge"
    * I set the token to the vendorId "<vendorId>"
    When I get charges through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<charge-file-name>" at folder "charge-service"

    # Simulation
    Given I have the payload at file "<simulation-file-name>" at folder "pricing-engine"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<simulation-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | timezone            | vendorId                             | price-file-name | deal-file-name | charge-file-name                  | simulation-file-name |
      #  BR: Price (MinimumPrice) + Deal (Simulation Date Time Condition, Line Item Condition, Deal Line Item Discount, Strategy Best Validation) + Charge (Payment Method Fee: Credit Card Pos)
      | BR      | America/Sao_Paulo   | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-prices       | br-deals       | br-charges                        | br-simulation1       |
      #  BR: Price (MinimumPrice) + Deal (Simulation Date Time Condition, Line Item Condition, Deal Line Item Discount) + Charge (Payment Method Fee / Bank Slip / ADF Promax 1 + ADF Robin (without dependsOnVendorChargeIds) / PaymentTerm 1)
      | BR      | America/Sao_Paulo   | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-prices       | br-deals       | br-charges                        | br-simulation2       |
      #  BR: Price (MinimumPrice) + Deal (Simulation Date Time Condition, Line Item Condition, Deal Line Item Discount) + Charge (Payment Method Fee / Bank Slip / ADF Promax 2 + ADF Robin (without dependsOnVendorChargeIds) / PaymentTerm 6)
      | BR      | America/Sao_Paulo   | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-prices       | br-deals       | br-charges                        | br-simulation3       |
      #  BR: Price (MinimumPrice) + Deal (Simulation Date Time Condition, Line Item Condition, Deal Line Item Discount) + Charge (Payment Method Fee / Bank Slip / ADF Robin (without dependsOnVendorChargeIds) / PaymentTerm 30)
      | BR      | America/Sao_Paulo   | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-prices       | br-deals       | br-charges                        | br-simulation4       |
      #  BR: Price (MinimumPrice) + Deal (Simulation Date Time Condition, Line Item Condition, Deal Line Item Discount) + Charge (Payment Method Fee / Bank Slip Installments / Ratio LINEAR / PaymentTerm 57)
      | BR      | America/Sao_Paulo   | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-prices-2     | br-deals       | bank-slip-installments-br-charges | br-simulation5       |
      #  BR: Price (MinimumPrice) + Deal (Delivery Date and Multiple Line Item Condition, Deal Multiple Line Item Discount) + Charge (OVERPRICE Credit BASE_PRICE_AFTER_DISCOUNT)
      | BR      | America/Sao_Paulo   | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-prices       | br-deals       | br-charges                        | br-simulation6       |
      # CO: Price (Simple Tax, Hidden Tax) + Deal (Line Item Condition, Multiple Line Item Condition, Multiple Line Item Discount, Line Item Scaled Discount) + Charge (Overprice, Delivery Date Fee)
      # !!!!!!! This scenario is failing, it needs to be analyzed
#      | CO      | America/Bogota      | co-prices       | co-deals       | co-charges                         | co-simulation        |
      # MX: Price (Promotional Price, Compound Tax, Charges) + Deal (Line Item Condition, Line Item Scaled Discount) + Charges (Overprice, Loan Deduction)
      | MX      | America/Mexico_City | eafe490e-fddc-4b01-900a-d0dc45194ab6 | mx-prices       | mx-deals       | mx-charges                        | mx-simulation        |