@ignore
Feature:  I want to be able to validate prices when we need to ignore rounding in pricing-engine

  Scenario Outline: Simulation of prices ignoring rounding

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have the "vendorId" header with value "<vendorId>"
    * I have dynamic market place ids
    * I generate the token to the vendorId "<vendorId>"

    # PUT Price
    Given I have the payload at file "<price-file-name>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Items
    Given I have the payload at file "<item-file-name>" at folder "item-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-item-v2"
    * I set the token to the vendorId "<vendorId>"
    When I create items through v2 endpoint
    Then The response code is "202" and the body is blank

    # GET Price
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price"
    * I have the payload at file "br-v3-request-ignore-rounding" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # GET Items
    Given I have the "vendorId" param with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-item"
    * I have the "vendorItemIds" param with value "VENDOR-SKU-BEESPR-16681,VENDOR-SKU-BEESPR-20479"
    * I set the token to the vendorId "<vendorId>"
    When I get items through v2 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<item-file-name>" at folder "item-service"

    # Simulation
    Given I have the payload at file "<simulation-file-name>" at folder "pricing-engine"
    * I have the "ignoreRounding" param with value "<ignore_rounding_value>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "<simulation-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | price-file-name              | simulation-file-name                                    | ignore_rounding_value          | item-file-name                      |
      | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-prices-v3-ignore-rounding | br-simulation-v2-ignore-browse-price-uom-rounding       | LINE_ITEM_BROWSE_PRICE_PER_UOM | br-items-v2-ignore-rounding-per-uom |
      | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-prices-v3-ignore-rounding | br-simulation-v2-ignore-line-item-subtotal-uom-rounding | LINE_ITEM_SUBTOTAL_PER_UOM     | br-items-v2-ignore-rounding-per-uom |
      | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 | br-prices-v3-ignore-rounding | br-simulation-v2-ignore-line-item-total-uom-rounding    | LINE_ITEM_TOTAL_PER_UOM        | br-items-v2-ignore-rounding-per-uom |
