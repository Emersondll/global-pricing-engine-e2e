@ok
Feature: I want to be able to run a offline simulation to get the simulation data based on itemIds with empties info

  Scenario Outline:  Simulation V2 Data with prices based on itemIds with empties info

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Prices VENDOR
    Given I have the "country" header with value "<country>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I put the timezone header
    * I have the payload at file "prices-v3-simulation-v2-data-vendor-with-empties" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Items
    Given I have the payload at file "items-v2-simulation-v2-data-with-empties" at folder "item-service"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-item-v2"
    * I set the token to the vendorId "<vendorId>"
    When I create items through v2 endpoint
    Then The response code is "202" and the body is blank

    # POST Empties
    Given I have the payload at file "<empties-v1-file>" at folder "empties-service"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-post-empty-v1"
    * I set the token to the vendorId "<vendorId>"
    When I create empties for ddc "<ddc>" through v1 endpoint
    Then The response code is "202" and the body is blank

    # POST Prices
    Given I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "post-request-prices-v3-simulation-v2-data-with-empties" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "prices-v3-simulation-v2-data-with-empties" at folder "price-service"

    # GET Items
    Given I have the "vendorId" param with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-get-item"
    * I have the "vendorItemIds" param with list values
      | VENDOR-SKU-BEESPR-17987-1 |
      | VENDOR-SKU-BEESPR-17987-2 |
      | VENDOR-SKU-BEESPR-17987-4 |
    * I set the token to the vendorId "<vendorId>"
    When I get items through v2 endpoint
    Then The response code is "200" and the body leniently matches the json at file "items-v2-simulation-v2-data-with-empties" at folder "item-service"

    # GET Empties
    Given I have the "vendorId" param with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-get-empty"
    * I have the "vendorItemIds" param with value "<vendorItemId>"
    * I set the token to the vendorId "<vendorId>"
    When I get empties through v2 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<empties-v2-file>" at folder "empties-service"

    # Simulation V2 Data
    Given I have the "country" header with value "<country>"
    * I have the delivery date header with current date
    * I have the "contractId" header with value dynamic contract id for key "1"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation-data"
    * I have the "itemIds" header with list values "<itemPlatformIds>"
    * I set the token to the vendorId "<vendorId>"
    When I perform a get into pricing-engine simulation-v2-data endpoint
    Then The response code is "<responseCode>" and the body matches the json at file "<simulation-data-response>" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             | responseCode | ddc  | vendorItemId                                        | empties-v1-file                   | empties-v2-file                   | simulation-data-response               | itemPlatformIds                                                                                                                                                                                                  |
      # Valid Line Item (Empty: BEESPR-17987-VENDOR-EMPTY-1 for VENDOR-SKU-BEESPR-17987-1 + BEESPR-17987-VENDOR-EMPTY-4 for VENDOR-SKU-BEESPR-17987-4 + VENDOR-SKU-BEESPR-17987-3)
      # vendorId used is DO "e2e exclusive" with country MX because rule empty-service
      | MX      | 63907b3e-3fb7-4f4c-b514-597c15c83042 | 200          | 0123 | VENDOR-SKU-BEESPR-17987-1,VENDOR-SKU-BEESPR-17987-4 | empties-v1-simulation-v2-data-200 | empties-v2-simulation-v2-data-200 | MX-simulation-v2-data-with-empties-200 | ## WILL BE REPLACED BY ITEM_ID WITH VENDOR_ITEM_ID 'VENDOR-SKU-BEESPR-17987-1' AND VENDOR KEY 'V-01' ##,## WILL BE REPLACED BY ITEM_ID WITH VENDOR_ITEM_ID 'VENDOR-SKU-BEESPR-17987-3' AND VENDOR KEY 'V-01' ##, |