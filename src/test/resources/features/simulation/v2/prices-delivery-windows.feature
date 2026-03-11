@ok
Feature: I want to be able to validate types of prices with flex delivery fee applied in simulation/v2

  Scenario Outline:  Simulation V2 of prices with a flex delivery fee

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Prices
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "br-prices-v3-vendor1-type-account" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # POST Delivery Windows
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "<delivery-windows-file>" at folder "delivery-window-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-delivery-windows"
    When I create delivery windows through v1 endpoint
    Then The response code is "202" and the body is blank

    # GET Prices
    Given I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "<price-request-file-name>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # GET Delivery Windows
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-delivery-windows"
    * I have the "deliveryWindowId" param with value "<delivery-window-id-param>"
    * I have the "pageSize" param with value "1"
    * I set the token to the vendorId "<vendorId>"
    When I get delivery windows through v1 endpoint
    Then The response code is "200" and the body matches the json at file "<delivery-windows-file>" at folder "delivery-window-service"

    # Simulation
    Given I have the payload at file "<simulation-file-name>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "<simulation-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | simulation-file-name                    | vendorId                             | price-request-file-name          | price-file-name                          | delivery-windows-file        | delivery-window-id-param                                                                                                    |
      | BR      | America/Sao_Paulo | br-simulation-v2-with-flex-delivery-fee | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-v3-post-request-with-one-item | br-prices-v3-simulation-v2-with-one-item | br-delivery-windows-flex-fee | ## WILL BE REPLACED BY DELIVERY_WINDOW_ID WITH VENDOR_DELIVERY_WINDOW_ID 'DW-ID-FLEX-BEESPR-T4533' AND VENDOR KEY 'V-01' ## |