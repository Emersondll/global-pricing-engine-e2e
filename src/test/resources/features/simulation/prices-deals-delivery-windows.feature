@ok
Feature:  I want to be able to validate rule to apply the delivery-window fee instead of delivery date fee from charges service

  Scenario Outline: Simulation of prices and delivery window instead charge service

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

    # PUT Charge
    Given I have the payload at file "<charge-file-name>" at folder "charge-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    * I set the token to the vendorId "<vendorId>"
    When I create charges through v2 endpoint
    Then The response code is "202" and the body is blank

    # POST Delivery Windows
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the payload at file "<delivery-windows-file>" at folder "delivery-window-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-post-delivery-windows"
    * I set the token to the vendorId "<vendorId>"
    When I create delivery windows through v1 endpoint
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

    # GET Charge
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-get-charge"
    * I set the token to the vendorId "<vendorId>"
    When I get charges through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<charge-file-name>" at folder "charge-service"

    # GET Delivery Windows
    Given I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-get-delivery-windows"
    * I have the "deliveryWindowId" param with value "<delivery-window-id-param>"
    * I have the "pageSize" param with value "1"
    * I set the token to the vendorId "<vendorId>"
    When I get delivery windows through v1 endpoint
    Then The response code is "200" and the body matches the json at file "<delivery-windows-file>" at folder "delivery-window-service"

    # Simulation
    Given I have the payload at file "<simulation-file-name>" at folder "pricing-engine"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<simulation-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | price-file-name | charge-file-name             | delivery-windows-file        | delivery-window-id-param                                                                                                    | simulation-file-name                                         |
      | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-prices       | br-charges-delivery-date-fee | br-delivery-windows-flex-fee | ## WILL BE REPLACED BY DELIVERY_WINDOW_ID WITH VENDOR_DELIVERY_WINDOW_ID 'DW-ID-FLEX-BEESPR-T4533' AND VENDOR KEY 'V-01' ## | br-simulation-v1-with-delivery-window-instead-charge-service |