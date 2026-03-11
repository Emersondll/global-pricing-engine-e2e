@ok
Feature: I want to be able to run a offline simulation to get the simulation data based on itemIds

  Scenario Outline:  Simulation V2 Data with prices based on itemIds

    # Generate Market Place Ids and token
    Given I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    # Set Time Zone by country
    * I set the timezone to the "<country>"
    # Generate Token
    * I generate the token to the vendorId "<vendorId>"
    # Generate VENDOR_ITEM_ID to be used as placeholder in the payloads
    * I have vendorId "<vendorId>" for key "V-01"

    # PUT Prices VENDOR
    Given I have the "country" header with value "<country>"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I put the timezone header
    * I have the payload at file "<country>-prices-v3-simulation-v2-data-vendor" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Prices ACCOUNT
    Given I have the "country" header with value "<country>"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I put the timezone header
    * I have the payload at file "<country>-prices-v3-simulation-v2-data-account" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

     # PUT Charges of type VENDOR through data-ingestion
    Given I have the payload at file "<country>-charges-v3-simulation-v2-data-vendor" at folder "data-ingestion"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    * I set the token to the vendorId "<vendorId>"
    When I create charges through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT Charges of type ACCOUNT through data-ingestion
    Given I have the payload at file "<country>-charges-v3-simulation-v2-data-account" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the "vendorId" header with value "<vendorId>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    * I set the token to the vendorId "<vendorId>"
    When I create charges through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT Deals of type VENDOR through data-ingestion
    Given I have the payload at file "<country>-deals-v3-simulation-v2-data-vendor" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the "vendorId" header with value "<vendorId>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-deals"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT Deals of type ACCOUNT through data-ingestion
    Given I have the payload at file "<country>-deals-v3-simulation-v2-data-account" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the "vendorId" header with value "<vendorId>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-deals"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # POST Combos
    Given I have the "country" header with value "<country>"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the payload at file "<country>-combos-v4-simulation-v2-data" at folder "combo-service"
    * I have the requestTraceId header with value starting with a "e2e-post-combo"
    * I have the "comboIds" header with list values
      | ## WILL BE REPLACED BY COMBO_ID WITH VENDOR_COMBO_ID 'VENDOR-COMBO-ID-BEESPR-17503-01' AND VENDOR KEY 'V-01' ## |
      | ## WILL BE REPLACED BY COMBO_ID WITH VENDOR_COMBO_ID 'VENDOR-COMBO-ID-BEESPR-17503-02' AND VENDOR KEY 'V-01' ## |
    * I set the token to the vendorId "<vendorId>"
    When I create combos through v3 endpoint
    Then The response code is "202" and the body is blank

    # GET Prices
    Given I have the "country" header with value "<country>"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "<country>-v3-post-request-simulation-v2-data" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-prices-v3-simulation-v2-data" at folder "price-service"

    # GET Charges
    Given I have the "country" header with value "<country>"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the requestTraceId header with value starting with a "e2e-get-charge"
    * I have the payload at file "<country>-charges-v3-data-ingestion-request-simulation-v2-data" at folder "charge-service"
    * I set the token to the vendorId "<vendorId>"
    When I get charges through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-charges-v3-data-ingestion-simulation-v2-data" at folder "charge-service"

    # GET Deals through POST method
    Given I have the "country" header with value "<country>"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the requestTraceId header with value starting with a "e2e-get-deals"
    * I have the payload at file "<country>-deals-v3-post-request-simulation-V2-data" at folder "deal-service"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-deals-v3-simulation-v2-data" at folder "deal-service"

    # GET Combos
    Given I have the "country" header with value "<country>"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "comboIds" header with list values
      | ## WILL BE REPLACED BY COMBO_ID WITH VENDOR_COMBO_ID 'VENDOR-COMBO-ID-BEESPR-17503-01' AND VENDOR KEY 'V-01' ## |
      | ## WILL BE REPLACED BY COMBO_ID WITH VENDOR_COMBO_ID 'VENDOR-COMBO-ID-BEESPR-17503-02' AND VENDOR KEY 'V-01' ## |
    * I have the dynamic comboAccountPlatformId param with dynamic vendor account id of key 1
    * I have the requestTraceId header with value starting with a "e2e-get-combo"
    * I set the token to the vendorId "<vendorId>"
    When I get combos through v4 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<country>-combos-v4-simulation-v2-data" at folder "combo-service"

    # Simulation V2 Data
    Given I have the "country" header with value "<country>"
    * I have the delivery date header with current date
    * I have the "contractId" header with value dynamic contract id for key "1"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation-data"
    * I have the "itemIds" header with list values
      | ## WILL BE REPLACED BY ITEM_ID WITH VENDOR_ITEM_ID 'VENDOR-SKU-BEESPR-16703-1' AND VENDOR KEY 'V-01' ##      |
      | ## WILL BE REPLACED BY ITEM_ID WITH VENDOR_ITEM_ID 'VENDOR-SKU-BEESPR-16703-2' AND VENDOR KEY 'V-01' ##      |
      | ## WILL BE REPLACED BY ITEM_ID WITH VENDOR_ITEM_ID 'VENDOR-SKU-BEESPR-16703-3' AND VENDOR KEY 'V-01' ##      |
      | ## WILL BE REPLACED BY ITEM_ID WITH VENDOR_ITEM_ID 'VENDOR-ITEM-ID-BEESPR-17503-01' AND VENDOR KEY 'V-01' ## |
      | ## WILL BE REPLACED BY ITEM_ID WITH VENDOR_ITEM_ID 'VENDOR-ITEM-ID-BEESPR-17503-02' AND VENDOR KEY 'V-01' ## |
      | ## WILL BE REPLACED BY ITEM_ID WITH VENDOR_ITEM_ID 'VENDOR-BEESPR-16705-1' AND VENDOR KEY 'V-01' ##          |
      | ## WILL BE REPLACED BY ITEM_ID WITH VENDOR_ITEM_ID 'VENDOR-BEESPR-16705-2' AND VENDOR KEY 'V-01' ##          |
      | ## WILL BE REPLACED BY ITEM_ID WITH VENDOR_ITEM_ID 'VENDOR-ITEM-BEESPR-16704-1' AND VENDOR KEY 'V-01' ##     |
      | ## WILL BE REPLACED BY ITEM_ID WITH VENDOR_ITEM_ID 'VENDOR-ITEM-BEESPR-16704-2' AND VENDOR KEY 'V-01' ##     |
    * I have the "comboIds" header with list values
      | ## WILL BE REPLACED BY COMBO_ID WITH VENDOR_COMBO_ID 'VENDOR-COMBO-ID-BEESPR-17503-01' AND VENDOR KEY 'V-01' ## |
      | ## WILL BE REPLACED BY COMBO_ID WITH VENDOR_COMBO_ID 'VENDOR-COMBO-ID-BEESPR-17503-02' AND VENDOR KEY 'V-01' ## |
    * I set the token to the vendorId "<vendorId>"
    When I perform a get into pricing-engine simulation-v2-data endpoint
    Then The response code is "200" and the body matches the json at file "<country>-simulation-v2-data" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             |
      | BR      | eafe490e-fddc-4b01-900a-d0dc45194ab6 |
