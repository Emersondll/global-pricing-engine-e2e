@ignore
Feature: I want to get the combos available for a customer

  Scenario Outline: Validate get combos through pricing-engine endpoint

    # Generate Market Place Ids and token
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

    # POST Combo
    Given I have the payload at file "<combo-file-name>" at folder "combo-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-combo"
    * I have the "vendorId" header with value "<vendorId>"
    * I set the token to the vendorId "<vendorId>"
    When I create combos through v3 endpoint
    Then The response code is "202" and the body is blank

    # POST Combo with score
    Given I have the payload at file "<combo-for-score-file-name>" at folder "combo-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-combo-for-score"
    * I have the "vendorId" header with value "<vendorId>"
    * I set the token to the vendorId "<vendorId>"
    When I create combos through v3 endpoint
    Then The response code is "202" and the body is blank

    # PATCH Combos with Score
    Given I have the payload at file "<combo-with-score-file-name>" at folder "combo-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-patch-combo-with-score"
    * I set the token to the vendorId "<vendorId>"
    When I update combos through v3 endpoint
    Then The response code is "202" and the body is blank

    # GET Price
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v2 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # GET Combos Service with Score
    Given I have the "vendorAccountId" param with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-combo-with-new-score"
    * I set the token to the vendorId "<vendorId>"
    When I get combos through v3 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<combo-with-score-file-name>" at folder "combo-service"

    # GET Combo through pricing-engine
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-combo"
    * I have the "vendorItemIds" param with list values
      | VENDOR-SKU-1 |
      | VENDOR-SKU-2 |
      | VENDOR-SKU-3 |
      | VENDOR-SKU-4 |
    * I set the token to the vendorId "<vendorId>"
    When I get combos through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<combo-response>" at folder "pricing-engine"

    Scenarios:
      | country | timezone        | vendorId                             | price-file-name | combo-file-name | combo-response | combo-for-score-file-name | combo-with-score-file-name |
      | CA      | America/Toronto | cbfe3f18-aa97-4fc7-8f72-ece748db2f06 | ca-prices       | ca-combos       | ca-combos      | ca-combos-for-score       | ca-combos-with-score       |