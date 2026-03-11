@ok
Feature: I want to get the deals with enforcement available by beesAccountId as vendorAccountId

  Scenario Outline: Pricing engine with a Coupon Code with vendorAccountId on the enforcementPlatformId (Deals V2 and Simulation V2)

    # Generate Market Place Ids, token
    Given I have vendorId "<vendorId>" for key "V-02"
    * I have dynamic delivery Center Id for key "2" and vendorId "<vendorId>"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"
    * I have dynamic tax Id for key "2"

    # PUT Enforcement V2 Limit to VENDOR 1 with limit > 0
    Given  I set the token to the vendorId "<vendorId>"
    * I have the payload at file "pe-quantity-limits-delivery-center-vendor-1-specific-user-coupon" at folder "enforcement-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-enforcement-vendor-ddc-specific-user-coupon"
    When I create promotion limit through v2 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deals V3
    Given I have the payload at file "pe-deals-v3-enforcement-data-ingestion-enforced-true-ddc-specific-user-coupon" at folder "deal-service"
    * I set the token to the vendorId "<vendorId>"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-deal-v3-vendor-ddc-specific-user-coupon"
    When I create deals through v3 endpoint
    Then The response code is "202" and the body is blank

    # POST Deals V3
    Given I have the payload at file "pe-request-deals-v3-ddc-specific-user-coupon" at folder "deal-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the requestTraceId header with value starting with a "e2e-post-deal-all-vendors-ddc-specific-user-coupon"
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "pe-deals-v2-deal-service-specific-user-coupon-response" at folder "deal-service"

    # GET Enforcement V4 limit
    Given I have the "country" header with value "<country>"
    * I set the token to the vendorId "<vendorId>"
    * I have the requestTraceId header with value starting with a "e2e-get-enforcement-v4-ddc-specific-user-coupon"
    * I have the "beesAccountId" param with value dynamic beesAccountId
    * I have vendor account id with value "bees-account-id-specific-user-coupon" for key "2"
    * I have the enforcement params with "2", "2", "<vendorId>", "PROMOTION" and "PROMOTION-SPECIFIC-USER-COUPON"
    When I get promotion limits through v4 endpoint
    Then The response code is "200" and the body leniently matches the json at file "pe-enforcement-ddc-v4-specific-user-coupon" at folder "enforcement-service"

    # POST Deals V2
    Given I have the payload at file "pe-deals-v2-request-ddc-enforcement-specific-user-coupon" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-pricing-engine-deals-v2-specific-user-coupon"
    * I have the "timezone" header with value "<timezone>"
    * I set the token to the vendorId "<vendorId>"
    When I get deals v2 through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "pe-deals-v2-pricing-engine-response-specific-user-coupon" at folder "pricing-engine"

    # POST Simulation V2
    Given I have the payload at file "simulation-v2-enforcement-deliveryCenter-specific-user-coupon" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I put the timezone header
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "pe-simulation-v2-enforcement-deliveryCenter-specific-user-coupon" at folder "pricing-engine"

    Scenarios:
      | country | timezone     | vendorId                              |
      | PE      | America/Lima | badb25b3-f4be-4bf3-b635-910d6d62271e  |