@ok
Feature: I want to do a preview of charges fees

  Scenario Outline: Validate charge preview with ADF Promax+Robin with more than one day

    # Generate Token
    Given I generate the token to the vendorId "<vendorId>"

    # PUT Charge
    Given I have the payload at file "<charge-request>" at folder "charge-service"
    * I have the "country" header with value "<country>"
    * I have the "timezone" header with value "<timezone>"
    * I have the x-timestamp header with current time
    * I have the requestTraceId header with value starting with a "e2e-put-charge"
    * I set the token to the vendorId "<vendorId>"
    When I create charges through v2 endpoint
    Then The response code is "202" and the body is blank

    # Get Charge Preview
    Given I have the "vendorId" header with value "<vendorId>"
    * I have the "vendorAccountId" header with value dynamic account id
    * I have the "country" header with value "<country>"
    * I have the requestTraceId header with value starting with a "e2e-get-charge-preview"
    * I have the "type" param with value "PAYMENT_METHOD_FEE"
    * I have the "total" param with value "500"
    * I set the token to the vendorId "<vendorId>"
    When I get charges through pricing-engine endpoint
    Then The response code is "200" and the body matches the json at file "<charge-response>" at folder "pricing-engine"

    Scenarios:
      | country | timezone          | vendorId                             | charge-request    | charge-response   |
      | BR      | America/Sao_Paulo | eafe490e-fddc-4b01-900a-d0dc45194ab6 | bank-slip-charges | br-charge-preview |

