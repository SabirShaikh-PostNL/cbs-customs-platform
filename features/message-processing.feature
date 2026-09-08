Feature: Processing inbound postal messages
  The message processing flows should submit valid messages and expose
  the expected item decisions in the MoaS application.

  @T001ValidateFromInputITMATTMessage
  Scenario: Validate ITMATT message processing
    When I send an ITMATT message with:
      | ItemIdPrefix              | UY                       |
      | ItemIdSuffix              | ES                       |
      | TotalWeight               | 0.2                      |
      | MailClass                 | U                        |
      | Gift                      | true                     |
      | TransportCosts            | 10.05                    |
      | TransportCurrency         | EUR                      |
      | OriginCountry             | ES                       |
      | ContentPieceHSCode        | 950300                   |
      | ContentPieceWeight        | 0.2                      |
      | ContentPieceNumberOfPieces | 1                       |
      | ContentPieceValue         | 24.00                    |
      | ContentPieceCurrency      | EUR                      |
      | ContentPieceOriginCountry | ES                       |
      | ContentPieceDescription   | Automated Test Stuff1    |
      | ReceiverName              | ART Receiver name no hnr |
      | ReceiverStreet            |                          |
      | ReceiverHouseNumber      |                          |
      | ReceiverHouseNumberAddition |                       |
      | ReceiverPostCode          |                          |
      | ReceiverCity              | Den Haag                 |
      | ReceiverCountry           | NL                       |
      | ReceiverTelephone         | 3165738957               |
      | ReceiverEmail             | testreceiver@email.com   |
      | SenderName                | ART Sender name          |
      | SenderStreetAndNumber     | Teststreet 11            |
      | SenderPostCode            | 08001                    |
      | SenderCity                | Barcelona                |
      | SenderCountry             | ES                       |
      | SenderTelephone           | 38957389                 |
      | SenderEmail               | testsender@email.com     |
    Then the message API response is successful
    And I log in to the MoaS application
    When I search for the generated item in Local entities Items
    Then the item has sorting decision "012 - Mold" and dutiable status "No"

  @T002ValidateFromInputPREDESMessage
  Scenario: Validate PREDES message processing
    When I send a PREDES message with:
      | Item1IdPrefix | RL |
      | Item1IdSuffix | IE |
      | Item2IdPrefix | RL |
      | Item2IdSuffix | IE |
      | Item3IdPrefix | RL|
      | Item3IdSuffix | IE |
      | PREDESPREFIX  | IEDUBANLHAGIAUN|
      | NumberOfItems | 3 |
    Then the message API response is successful
    And I log in to the MoaS application
    When I search for the generated item in Local entities Items
    Then the item has sorting decision "013 - PNP" and dutiable status "No"
    When I search for the generated item in Processed requests
    Then the processed request has message name "predes" and flags:
      | Is processed | Yes |
      | Is error     | No  |
      | Is failed    | No  |

  @T020DataIncompleteOtherNEU005NoPREDESToRICK
  Scenario: Validate ITMATT message processing for Data Incomplete
  When I send an ITMATT message with:
    | ItemIdPrefix                | LX                       |
    | ItemIdSuffix                | US                       |
    | TotalWeight                 | 0.2                      |
    | MailClass                   | E                        |
    | Gift                        | false                    |
    | TransportCosts              | 10.05                    |
    | TransportCurrency           | EUR                      |
    | OriginCountry               | US                       |
    | ContentPieceHSCode          | 950300                   |
    | ContentPieceWeight          | 0.2                      |
    | ContentPieceNumberOfPieces  | 1                        |
    | ContentPieceValue           | 300.00                   |
    | ContentPieceCurrency        | USD                      |
    | ContentPieceOriginCountry   | US                       |
    | ContentPieceDescription     | Automated Test Stuff1    |
    | ReceiverName                | ART Receiver name no hnr |
    | ReceiverStreet              |                          |
    | ReceiverHouseNumber         |                          |
    | ReceiverHouseNumberAddition |                          |
    | ReceiverPostCode            |                          |
    | ReceiverCity                | Den Haag                 |
    | ReceiverCountry             | NL                       |
    | ReceiverTelephone           | 3165738957               |
    | ReceiverEmail               | testreceiver@email.com   |
    | SenderName                  | ART Sender name two      |
    | SenderStreetAndNumber       | 1567 Broadway            |
    | SenderPostCode              | 10036                    |
    | SenderCity                  | New York                 |
    | SenderCountry               | US                       |
    | SenderTelephone           | 38957389                 |
    | SenderEmail               | testsender@email.com     |
  Then the message API response is successful
  And I log in to the MoaS application
  When I search for the generated item in Local entities Items
  Then the item has sorting decision "005 - Data incomplete other" and dutiable status ""

@T051Sorting013-PNP-ItmattEUGiftNoPREDES
Scenario: Validate ITMATT message processing for 013
  When I send an ITMATT message with:
    | ItemIdPrefix                | RL                |
    | ItemIdSuffix                | ES                |
    | TotalWeight                 | 0.2               |
    | MailClass                   | E                 |
    | Gift                        | false             |
    | TransportCosts              | 10.05             |
    | TransportCurrency           | EUR               |
    | OriginCountry               | ES                |
    | ContentPieceHSCode          | 950300                   |
    | ContentPieceWeight          | 0.2                      |
    | ContentPieceNumberOfPieces  | 1                        |
    | ContentPieceValue           | 100.00                   |
    | ContentPieceCurrency        | USD                      |
    | ContentPieceOriginCountry   | US                       |
    | ContentPieceDescription     | Automated Test Stuff1    |
    | ReceiverName                | ART Receiver name |
    | ReceiverStreet              | Loire             |
    | ReceiverHouseNumber         | 1                 |
    | ReceiverHouseNumberAddition |                   |
    | ReceiverPostCode            | 2491 AN           |
    | ReceiverCity                | Den Haag          |
    | ReceiverCountry             | NL                |
    | ReceiverTelephone           | 3165738957        |
    | ReceiverEmail               | testreceiver@email.com |
    | SenderName                  | ART Sender name   |
    | SenderStreetAndNumber       | Teststreet 11     |
    | SenderPostCode              | 08001             |
    | SenderCity                  | Barcelona         |
    | SenderCountry               | ES                |
    | SenderTelephone             | 38957389          |
    | SenderEmail                 | testsender@email.com |
  Then the message API response is successful
  And I log in to the MoaS application
  When I search for the generated item in Local entities Items
  Then the item has sorting decision "013" and dutiable status "No"

