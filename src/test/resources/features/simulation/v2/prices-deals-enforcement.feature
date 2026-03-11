@ok
Feature: I want to simulate deals with enforcement limits for a customer on pricing-engine/v2/simulation

  Scenario Outline:   Simulation V2 with enforcement limits and deals with and without enforced

    # Generate Market Place Ids, token and taxId
    Given I have vendorId "<vendorId_ambev>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId_ambev>"
    * I have dynamic price list Id for key "1"
    * I have dynamic tax Id for key "1"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId_ambev>"

    # PUT Contract for AMBEV. Note: only to create bees-account
    Given I set the token to the vendorId "<vendorId_ambev>"
    * I have the payload at file "br-account-simulation-v2" at folder "account-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-account-vendor-1"
    When I create account through v1 endpoint
    Then The response code is "202" and the body is blank

    # PUT Prices
    Given I set the token to the vendorId "<vendorId_ambev>"
    * I have the payload at file "<price-file-name>" at folder "price-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price-v3-"
    When I create prices through v3 endpoint
    Then The response code is "202" and the body is blank

    # PUT Deals through data-ingestion
    Given I have the payload at file "<deal-file-name>" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I set the timezone to the "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-deals"
    * I set the token to the vendorId "<vendorId_ambev>"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # PUT Enforcemet V2 Limit
    Given I have the payload at file "<enforcement-file-name>" at folder "enforcement-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-enforcement-"
    * I set the token to the vendorId "<vendorId_ambev>"
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
    * I set the token to the vendorId "<vendorId_ambev>"
    When I get account through v2 endpoint
    Then The response code is "200" and the body leniently matches the json at file "br-account-simulation-v2-enforcement" at folder "account-service"

    # POST Prices
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-price-v3-all-vendors"
    * I have the payload at file "<price-request-file-name>" at folder "price-service"
    * I set the token to the vendorId "<vendorId_ambev>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # GET Deals through POST method
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-deals"
    * I have the payload at file "<deal-request-file-name>" at folder "deal-service"
    * I set the token to the vendorId "<vendorId_ambev>"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<deal-file-name>" at folder "deal-service"

    # GET Enforcement V4 limit
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-enforcement-v4"
    * I have the "beesAccountId" param with value dynamic beesAccountId
    * I have the enforcement params with "1", "1", "<vendorId_ambev>", "PROMOTION" and "VENDOR-PROMO-1"
    * I have the enforcement params with "1", "2", "<vendorId_ambev>", "PROMOTION" and "VENDOR-PROMO-2"
    * I have the enforcement params with "1", "3", "<vendorId_ambev>", "PROMOTION" and "VENDOR-PROMO-3"
    * I have the enforcement params with "1", "4", "<vendorId_ambev>", "PROMOTION" and "VENDOR-PROMO-4"
    * I set the token to the vendorId "<vendorId_ambev>"
    When I get promotion limits through v4 endpoint
    Then The response code is "207" and the body leniently matches the json at file "<enforcement-file-name>" at folder "enforcement-service"

    # Simulation
    # Description:
    # "VENDOR-DEAL-1" has enfocerd = true and enforcement with partial limits -> Deal shold be parcial applied
    # "VENDOR-DEAL-2" has enfocerd = true and no enforcerment registered -> Shold not be apply
    # "VENDOR-DEAL-3" has enfocerd = null and no enforcerment registered -> Shold be total apply
    # "VENDOR-DEAL-4" has enfocerd = false and enforcement with partial limits -> Shold be apply the entire deal
    Given I have the payload at file "<simulation-file>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I put the timezone header
    * I set the token to the vendorId "<vendorId_ambev>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "<simulation-file>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId_ambev                       | price-request-file-name                        | price-file-name                        | deal-file-name                     | deal-request-file-name                     | enforcement-file-name                      | simulation-file              |
      | BR      | America/Sao_Paulo | 7a51f522-c3e3-421b-89d8-290d8eb2eddd | br-request-prices-v3-simulation-v2-enforcement | br-prices-v3-simulation-v2-enforcement | br-deals-v3-simulation-enforcement | br-request-deals-v3-simulation-enforcement | br-budget-limits-simulation-v2-enforcement | br-simulation-v2-enforcement |