@later
Feature: I want to be able to validate the enforcement limits v4 on simulation/v2 integration

  Scenario Outline:  Simulation V2 with prices and deals v3 to validate the enforcement limits v4

    # Generate Market Place Ids
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId>"
    * I have dynamic price list Id for key "1"
    * I have dynamic tax Id for key "1"
    # Set Time Zone by country
    * I set the timezone to the "<country>"
    # Generate Token
    * I generate the token to the vendorId "<vendorId>"

    # PUT Contract. Note: only to create bees-account
    Given I have the payload at file "account-v1-for-limit-by-enforcement" at folder "account-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-account-vendor-1"
    * I set the token to the vendorId "<vendorId>"
    When I create account through v1 endpoint
    Then The response code is "202" and the body is blank

    # PUT Prices to VENDOR_ID 1 with prices type ACCOUNT through price-relay
    Given I have the payload at file "prices-v3-for-limit-by-enforcement" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deals of type ACCOUNT through data-ingestion
    Given I have the payload at file "deals-v3-for-limit-by-enforcement" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-deals"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT Enforcemet V2 Limit to VENDOR 1 with balance = zero
    Given  I set the token to the vendorId "<vendorId>"
    * I have the payload at file "<enforcement-file>" at folder "enforcement-service"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-enforcement"
    When I create promotion limit through v2 endpoint
    Then The response code is "202" and the body is blank

    # GET Account
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-account"
    * I have the x-timestamp header with current time
    * I have the "projection" param with list values
      | priceListId      |
      | deliveryCenterId |
    * I have the "id" param with the list of all contractIds values
    * I set the token to the vendorId "<vendorId>"
    When I get account through v2 endpoint
    Then The response code is "200" and the body leniently matches the json at file "account-v1-for-limit-by-enforcement" at folder "account-service"

    # GET Prices by POST method
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price-v3"
    * I have the payload at file "prices-v3-request-for-limit-by-enforcement" at folder "price-service"
    * I put the timezone header
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "prices-v3-for-limit-by-enforcement" at folder "price-service"

    # GET Deals through POST method
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-deals"
    * I have the payload at file "deals-v3-request-for-limit-by-enforcement" at folder "deal-service"
    * I put the timezone header
    * I set the token to the vendorId "<vendorId>"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "deals-v3-for-limit-by-enforcement" at folder "deal-service"

    # GET Enforcement V4 limit by enforcement-type
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-enforcement-v4"
    * I have the "beesAccountId" param with value dynamic beesAccountId
    # CC-20103-1 enforced=true, E with balance > 0: Deal should be applied.
    * I have the enforcement params with "1", "1", "<vendorId>", "PROMOTION" and "VENDOR-PROMO-EID-BEESPR-20103-1"
    # CC-20103-2 enforced=true, E with balance = 0: Deal shouldn't be applied.
    * I have the enforcement params with "1", "2", "<vendorId>", "PROMOTION" and "VENDOR-PROMO-EID-BEESPR-20103-2"
    # CC-20103-3 enforced=true but there is no enforcement..: Deal shouldn't be applied.
    * I have the enforcement params with "1", "3", "<vendorId>", "PROMOTION" and "VENDOR-PROMO-EID-BEESPR-20103-3"
    # CC-20103-4 enforced = null and enableEnforcementServiceIntegration is ON and E with balance > 0: Deal should be applied.
    * I have the enforcement params with "1", "4", "<vendorId>", "PROMOTION" and "VENDOR-PROMO-EID-BEESPR-20103-4"
    # CC-20103-5 enforced = null and enableEnforcementServiceIntegration is ON and E with balance = 0: Deal shouldn't be applied.
    * I have the enforcement params with "1", "5", "<vendorId>", "PROMOTION" and "VENDOR-PROMO-EID-BEESPR-20103-5"
    # CC-20103-6 enforced=null and enableEnforcementServiceIntegration is ON and there is no enforcement..: Deal should be applied.
    * I have the enforcement params with "1", "6", "<vendorId>", "PROMOTION" and "VENDOR-PROMO-EID-BEESPR-20103-6"
    # CC-20103-7 enforced=false: Deal applied without check the enforcement-service
    * I have the enforcement params with "1", "7", "<vendorId>", "PROMOTION" and "VENDOR-PROMO-EID-BEESPR-20103-7"
    * I set the token to the vendorId "<vendorId>"
    When I get promotion limits through v4 endpoint
    Then The response code is "207" and the body leniently matches the json at file "<enforcement-file>" at folder "enforcement-service"

    # Simulation
    Given I have the payload at file "<pricing-engine-file>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "<pricing-engine-file>" at folder "pricing-engine"

    # Enforcement not working for BR Zone changed to PE Zone 08-02-2023
    # BEESPR-20103
    # Toggle configuration enableEnforcementServiceIntegration is On to ar,br,co,mx,pa,pe
    # Toggle configuration enableEnforcementServiceIntegrationV2 is On to ar,br,co,mx,pe
    Scenarios:
      | country | vendorId                             | enforcement-file                       | pricing-engine-file                                     |
      | PE      | badb25b3-f4be-4bf3-b635-910d6d62271e | enforcement-v4-for-availability        | PE-simulation-v2-for-limit-by-enforcement-availabilitys |
      | PE      | badb25b3-f4be-4bf3-b635-910d6d62271e | enforcement-v4-for-shared-availability | PE-simulation-v2-for-limit-by-enforcement-availabilitys |