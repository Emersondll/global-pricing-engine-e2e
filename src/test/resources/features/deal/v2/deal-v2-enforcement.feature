@ignore
Feature: I want to get the deals with enforcement available for a customer on pricing-engine/deals v2

  Scenario Outline:  Validate retrieve deals v2 with enforcement through pricing-engine endpoint

    # Generate Market Place Ids, token and taxId
    Given I have vendorId "<vendorId>" for key "V-01"
    Given I have vendorId "<vendorId_2>" for key "V-02"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic contract Id for key "2" and vendorId "<vendorId_2>"
    * I generate the token to the vendorId "<vendorId>"
    * I generate the token to the vendorId "<vendorId_2>"

     # PUT Prices to VENDOR 1 with prices type ACCOUNT
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "pe-prices-v3-vendor1-type-account" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3-vendor-1"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

     # PUT Prices to VENDOR 2 with prices type ACCOUNT
    Given I set the token to the vendorId "<vendorId_2>"
    * I have the payload at file "pe-prices-v3-vendor2-type-account" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3-vendor-2"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deals to VENDOR 1 with prices type ACCOUNT
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "pe-deals-vendor-1-enforced-<enforced>" at folder "deal-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal-vendor-1"
    When I create deals through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deals to VENDOR 2 with prices type ACCOUNT
    Given I set the token to the vendorId "<vendorId_2>"
    * I have the payload at file "pe-deals-vendor-2-enforced-<enforced>" at folder "deal-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal-vendor-2"
    When I create deals through v2 endpoint
    Then The response code is "202" and the body is blank

   # PUT Enforcemet V2 Limit to VENDOR 1 with balance > zero
    Given  I set the token to the vendorId "<vendorId>"
    * I have the payload at file "br-quantity-limits-vendor-1" at folder "enforcement-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-enforcement-vendor-1"
    When I create promotion limit through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Enforcemet V2 Limit to VENDOR 2 with balance = zero
    Given  I set the token to the vendorId "<vendorId_2>"
    * I have the payload at file "br-budget-limits-vendor-2" at folder "enforcement-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-enforcement-vendor-2"
    When I create promotion limit through v2 endpoint
    Then The response code is "202" and the body is blank

    # POST Prices to All Vendors
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-price-v3-all-vendors"
    * I have the payload at file "<price-request-file-name>" at folder "price-service"
    * I set the token to the vendorId "<vendorId_2>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # POST Deals to All Vendors
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-deal-all-vendors"
    * I have the payload at file "pe-deals-v3-post-request-enforcement" at folder "deal-service"
    * I set the token to the vendorId "<vendorId_2>"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "pe-deals-v3-enforced-<enforced>" at folder "deal-service"

    # GET Enforcement V4 limit
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-enforcement-v4"
    * I have the "beesAccountId" param with value dynamic beesAccountId
    * I have the enforcement params with "1", "1", "<vendorId>", "FREEGOOD" and "VENDOR-PROMO-2"
    * I have the enforcement params with "2", "2", "<vendorId_2>", "PROMOTION" and "VENDOR-PROMO-1"
    * I set the token to the vendorId "<vendorId_2>"
    When I get promotion limits through v4 endpoint
    Then The response code is "200" and the body leniently matches the json at file "<enforcement-file-name>" at folder "enforcement-service"

    # POST Deal V2 through pricing-engine
    Given I have the payload at file "<deal-v2-file-name>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-pricing-engine-deals-v2"
    * I have the "timezone" header with value "<timezone>"
    * I set the token to the vendorId "<vendorId_2>"
    When I get deals v2 through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<deal-v2-file-name-response>" at folder "pricing-engine"

    Scenarios:
      | country | timezone     | vendorId                             | vendorId_2                           | price-request-file-name         | price-file-name           | enforcement-file-name | deal-v2-file-name       | deal-v2-file-name-response             | enforced |
      | PE      | America/Lima | badb25b3-f4be-4bf3-b635-910d6d62271e | 42f582e0-eacb-49fe-95db-e35793615b2b | pe-v3-post-request-only-account | pe-prices-v3-only-account | pe-limits-v4          | pe-deals-v2-enforcement | pe-deals-v2-enforcement-enforced-null  | null     |
      | PE      | America/Lima | badb25b3-f4be-4bf3-b635-910d6d62271e | 42f582e0-eacb-49fe-95db-e35793615b2b | pe-v3-post-request-only-account | pe-prices-v3-only-account | pe-limits-v4          | pe-deals-v2-enforcement | pe-deals-v2-enforcement-enforced-true  | true     |
      | PE      | America/Lima | badb25b3-f4be-4bf3-b635-910d6d62271e | 42f582e0-eacb-49fe-95db-e35793615b2b | pe-v3-post-request-only-account | pe-prices-v3-only-account | pe-limits-v4          | pe-deals-v2-enforcement | pe-deals-v2-enforcement-enforced-false | false    |