@ignore
Feature: I want to be able to validate the deals new orderTotal and orderSubtotal filter

  Scenario Outline:  pricing-engine DealsV2 filter by orderTotal and orderSubtotal

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I have dynamic contract Id for key "2" and vendorId "<vendorId>"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Deals of type ACCOUNT through data-ingestion
    Given I have the payload at file "BR-deals-v3-order-total-and-sub-total-data-ingestion" at folder "data-ingestion"
    * I have the "country" header with value "<country>"
    * I put the timezone header
    * I have the requestTraceId header with value starting with a "e2e-put-deals"
    * I set the token to the vendorId "<vendorId>"
    When I create deals through data ingestion endpoint
    Then The response code is "202" and the body is blank

     # POST to get deals
    Given I have the "country" header with value "<country>"
    * I set the token to the vendorId "<vendorId>"
    * I have the requestTraceId header with value starting with a "e2e-post-deal-all"
    * I have the "types" param with value "COUPON"
    * I have the payload at file "br-deals-v3-post-request-data-ingestion" at folder "deal-service"
    When I get deals through v3 endpoint
    Then The response code is "200" and the body matches the json at file "BR-deals-v3-order-total-and-sub-total-data-ingestion" at folder "deal-service"

    # GET Deals through POST method
    Given I have the payload at file "<deals-pricing-request>" at folder "pricing-engine"
    * I set the token to the vendorId "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-deals"
    * I have the "types" param with value "<types>"
    When I get deals v2 through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<deals-pricing-response>" at folder "pricing-engine"

    Scenarios:
      | country  | vendorId                             | deals-pricing-request                 | deals-pricing-response          | types  |
      | BR       | 7a51f522-c3e3-421b-89d8-290d8eb2eddd | deals-v3-request-order-total-filter   | deals-v2-response-order-total   | COUPON  |
      | BR       | 7a51f522-c3e3-421b-89d8-290d8eb2eddd | deals-v3-request-ordersubtotal-filter | deals-v2-response-orderSubtotal | COUPON  |