@ignore
Feature: I want to do a preview of charges v2 fees

  Scenario Outline: Validate charge preview v2 fees, one from delivery window and one from charges

    # Generate Market Place Ids and token
    Given I have vendorId "<vendorId>" for key "V-01"
    * I have dynamic contract Id for key "1" and vendorId "<vendorId>"
    * I set the timezone to the "<country>"
    * I generate the token to the vendorId "<vendorId>"

    # PUT Charge
    Given I have the payload at file "<charge-relay-request>" at folder "charge-service"
    * I have the "vendorId" header with value "<vendorId>"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    * I set the token to the vendorId "<vendorId>"
    When I create charges through v3 endpoint
    Then The response code is "202" and the body is blank

    # POST Delivery Windows
    Given I set the token to the vendorId "<vendorId>"
    * I have the payload at file "<delivery-windows-file>" at folder "delivery-window-service"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-post-delivery-windows"
    When I create delivery windows through v1 endpoint
    Then The response code is "202" and the body is blank

    # Get Charge V2 Preview
    Given I have the "contractId" header with value dynamic contract id for key "1"
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-charge-v2-preview"
    * I have the "deliveryWindowIds" param with list values
      | NnY1SkR2M2NTd0dRQ3REY1JSbEt0Zz09O0RXSUQtMDAx |
      | NnY1SkR2M2NTd0dRQ3REY1JSbEt0Zz09O0RXSUQtMDAz |
    * I have the "total" param with value "500"
    * I set the token to the vendorId "<vendorId>"
    When I get charges v2 through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<charge-final-response>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | charge-relay-request                 | delivery-windows-file                    | charge-final-response   |
      | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 | charges-v3-type-delivery-date-fee    | br-delivery-windows-flex-and-regular-fee | br-charge-preview-v2       |

