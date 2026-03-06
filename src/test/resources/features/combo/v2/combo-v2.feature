@ignore
Feature: I want to get the combos available for a customer on combos v2 using relay service

  Scenario Outline: Validate get combos through combos v2 from pricing-engine endpoint using relay service
    # BEESPR-15567 - [Marketplace] Business tier - Combos

    # Generate Market Place Ids and token
    Given I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Price
    Given I have the payload at file "<country>-prices-v3-combos-v2-combos-v4" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v2 endpoint
    Then The response code is "202" and the body is blank

    # POST Combos COMBOS_ACCOUNTS
    Given I have the payload at file "<country>-combos-v2-combos-v4" at folder "combo-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-combo"
    * I have the "vendorId" header with value "<vendorId>"
    * I put the timezone header
    * I set the token to the vendorId "<vendorId>"
    When I create combos through v3 endpoint
    Then The response code is "202" and the body is blank

    # GET Prices
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "<country>-request-prices-v3-combos-v2-combos-v4" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-prices-v3-combos-v2-combos-v4" at folder "price-service"

    # GET Combos for Account
    Given I have the "country" header with value "<country>"
    * I have combo account platform Id for key "1" with comboId "VENDOR-COMBO-BEESPR-15567-1" and vendorId "<vendorId>"
    * I have combo account platform Id for key "2" with comboId "VENDOR-COMBO-BEESPR-15567-2" and vendorId "<vendorId>"
    * I have combo account platform Id for key "3" with comboId "VENDOR-COMBO-BEESPR-20479-3" and vendorId "<vendorId>"
    * I have the platformsIds with comboIds done
    * I have the requestTraceId header with value starting with a "e2e-get-combo"
    * I set the token to the vendorId "<vendorId>"
    When I get combos through v4 endpoint
    Then The response code is "200" and the body matches the json at file "<country>-combos-v2-combos-v4" at folder "combo-service"

    # GET Combo (POST V2) through pricing-engine
    Given I have the payload at file "<country>-combos-v2-combos-v4" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-combos-v2"
    * I set the token to the vendorId "<vendorId>"
    When I get combos v2 through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<country>-combos-v2-combos-v4" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             |
      | BR      | 7a51f522-c3e3-421b-89d8-290d8eb2eddd |