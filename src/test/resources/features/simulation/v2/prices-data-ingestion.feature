@ok
Feature:  I want to be able to validate prices created through data-ingestion on pricing-engine

  Scenario Outline: Simulation of prices created through data-ingestion

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic delivery Center Id for key "2" and vendorId "<vendorId>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Price of type VENDOR through data-ingestion
    Given I have the payload at file "<country>-prices-v3-simulation-v2-vendor" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through data-ingestion
    Then The response code is "202" and the body is blank

    # PUT Price of type ACCOUNT or DELIVERY CENTER through data-ingestion
    Given I have the payload at file "<data-ingestion-file-name>" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-price"
    * I set the token to the vendorId "<vendorId>"
    When I create prices through data-ingestion
    Then The response code is "202" and the body is blank

    # GET Price
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-price"
    * I have the payload at file "<price-request-file-name>" at folder "price-service"
    * I set the token to the vendorId "<vendorId>"
    When I get prices through v3 endpoint
    Then The response code is "200" and the body matches the json at file "<price-file-name>" at folder "price-service"

    # Simulation
    Given I have the payload at file "<simulation-file-name>" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "<simulation-file-name>" at folder "pricing-engine"

    Scenarios:
      | vendorId                             | country | timezone             | data-ingestion-file-name                  | price-request-file-name      | price-file-name             | simulation-file-name                  |
      | 2a8e7e9f-6492-4a4d-a5a9-6d78f1fa3d8a | TZ      | Africa/Dar_es_Salaam | TZ-prices-v3-simulation-v2-deliveryCenter | tz-v3-request-data-ingestion | tz-prices-v3-data-ingestion | tz-simulation-v2-using-data-ingestion |
      | eafe490e-fddc-4b01-900a-d0dc45194ab6 | BR      | America/Sao_Paulo    | BR-prices-v3-simulation-v2-account        | br-v3-request-data-ingestion | br-prices-v3-data-ingestion | br-simulation-v2-using-data-ingestion |