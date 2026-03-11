@ok
Feature: I want to be able to validate charges on the simulation with firstOrder in simulation/v2

  Scenario Outline:  Simulation V2 for a zone with an order with firstOrder condition and a first order delivery fee

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic delivery Center Id for key "1" and vendorId "<vendorId>"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Charges of type DELIVERY_CENTER through data-ingestion
    Given I have the payload at file "charges-v3-simulation-v2-ddc-fistOrder" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    * I put the timezone header
    * I have the x-timestamp header with current time
    * I set the token to the vendorId "<vendorId>"
    When I create charges through data ingestion endpoint
    Then The response code is "202" and the body is blank

    # GET Charges
    Given I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-charge"
    * I have the payload at file "request-charges-v3-simulation-v2-fistOrder" at folder "charge-service"
    * I set the token to the vendorId "<vendorId>"
    When I get charges through v3 endpoint
    Then The response code is "200" and the body matches the json at file "charges-v3-simulation-v2-firstOrder" at folder "charge-service"

    # Simulation
    Given I have the payload at file "simulation-v2-firstOrder" at folder "pricing-engine"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-simulation"
    * I put the timezone header
    * I set the token to the vendorId "<vendorId>"
    When I simulate a cart in pricing-engine on v2 endpoint
    Then The response code is "200" and the body matches the json at file "<simulation-response-file-name>" at folder "pricing-engine"

    Scenarios:
      | country | vendorId                             | simulation-response-file-name       |
      # For TZ zoned no apply charges on Combos object due the reverseCombo
      | TZ      | 2a8e7e9f-6492-4a4d-a5a9-6d78f1fa3d8a | TZ-simulation-v2-charges-firstOrder |