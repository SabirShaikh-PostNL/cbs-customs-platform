Feature: Processing inbound postal messages
  The message processing flows should submit valid messages and expose
  the expected item decisions in the MoaS application.


# =====================================================================================
# T001ValidateFromInputITMATTMessage
# =====================================================================================
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


# ====================================================================================
# T002ValidateFromInputPREDESMessage
# ====================================================================================
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


# ====================================================================================
# T020DataIncompleteOtherNEU005NoPREDESToRICK
# ====================================================================================
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


# ====================================================================================
# T051Sorting013-PNP-ItmattEUGiftNoPREDES
# ====================================================================================
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


# =====================================================================================
# T101Sorting103-SchiedamRetourenFrom012
# =====================================================================================
@T101Sorting103-SchiedamRetourenFrom012
Scenario: Validate that an item is assigned sorting decision 103 - Schiedam retouren after receiving PREDES and ITMATT data
When I send a PREDES message with:
  | Item1IdPrefix | LR              |
  | Item1IdSuffix | NL              |
  | PREDESPREFIX  | ESDUBANLHAGIAUN |
  | NumberOfItems | 1               |
Then the message API response is successful
And I send an ITMATT message with:
  | ItemIdPrefix                | LR                    |
  | ItemIdSuffix                | NL                    |
  | TotalWeight                 | 0.2                   |
  | MailClass                   | U                     |
  | Gift                        | false                 |
  | TransportCosts              | 10.05                 |
  | TransportCurrency           | EUR                   |
  | OriginCountry               | ES                    |
  | ContentPieceHSCode          | 950300                |
  | ContentPieceWeight          | 0.2                   |
  | ContentPieceNumberOfPieces  | 1                     |
  | ContentPieceValue           | 300.00                |
  | ContentPieceCurrency        | USD                   |
  | ContentPieceOriginCountry   | ES                    |
  | ContentPieceDescription     | Automated Test Stuff1 |
  | ReceiverName                | ART Receiver name     |
  | ReceiverStreet              | Loire                 |
  | ReceiverHouseNumber         | 1                     |
  | ReceiverHouseNumberAddition |                       |
  | ReceiverPostCode            | 2491 AN               |
  | ReceiverCity                | Den Haag              |
  | ReceiverCountry             | NL                    |
  | ReceiverTelephone           | 3165738957            |
  | ReceiverEmail               | testreceiver@email.com|
  | SenderName                  | ART Sender name       |
  | SenderStreetAndNumber       | Teststreet 11         |
  | SenderPostCode              | 08001                 |
  | SenderCity                  | Barcelona             |
  | SenderCountry               | ES                    |
  | SenderTelephone             | 38957389              |
  | SenderEmail                 | testsender@email.com  |
Then the message API response is successful
When I log in to the MoaS application
And I search for the generated item in Local entities Items
Then the item has sorting decision "103 - Schiedam retouren" and dutiable status "No"
When I search for the generated item in Messages sent to eMagiz
Then the generated item has messages in Messages sent to eMagiz:
  | MessageType   | Target                           |
  | Kafka Message | nl.postnl.pnlecus.accp.sortdecs |
Then the eMagiz payload for target "nl.postnl.pnlecus.accp.sortdecs" matches:
  | JSON path         | Expected value   |
  | $.ItemId          | Generated ItemId |
  | $.SortingDecision | _103             |


# =====================================================================================
# T102Sorting103-SchiedamRetourenFrom013
# =====================================================================================
@T102Sorting103-SchiedamRetourenFrom013
Scenario: Validate that an item is assigned sorting decision 103 - Schiedam retouren after receiving PREDES and ITMATT data for an item that previously resulted in SD013
When I send a PREDES message with:
  | Item1IdPrefix | UT              |
  | Item1IdSuffix | NL              |
  | PREDESPREFIX  | ESDUBANLHAGIAUX |
  | NumberOfItems | 1               |
Then the message API response is successful
And I send an ITMATT message with:
  | ItemIdPrefix                | UT                    |
  | ItemIdSuffix                | NL                    |
  | TotalWeight                 | 0.2                   |
  | MailClass                   | U                     |
  | Gift                        | false                 |
  | TransportCosts              | 10.05                 |
  | TransportCurrency           | EUR                   |
  | OriginCountry               | ES                    |
  | ContentPieceHSCode          | 950300                |
  | ContentPieceWeight          | 0.2                   |
  | ContentPieceNumberOfPieces  | 1                     |
  | ContentPieceValue           | 300.00                |
  | ContentPieceCurrency        | USD                   |
  | ContentPieceOriginCountry   | ES                    |
  | ContentPieceDescription     | Automated Test Stuff1 |
  | ReceiverName                | ART Receiver name     |
  | ReceiverStreet              | Loire                 |
  | ReceiverHouseNumber         | 1                     |
  | ReceiverHouseNumberAddition |                       |
  | ReceiverPostCode            | 2491 AN               |
  | ReceiverCity                | Den Haag              |
  | ReceiverCountry             | NL                    |
  | ReceiverTelephone           | 3165738957            |
  | ReceiverEmail               | testreceiver@email.com|
  | SenderName                  | ART Sender name       |
  | SenderStreetAndNumber       | Teststreet 11         |
  | SenderPostCode              | 08001                 |
  | SenderCity                  | Barcelona             |
  | SenderCountry               | ES                    |
  | SenderTelephone             | 38957389              |
  | SenderEmail                 | testsender@email.com  |
Then the message API response is successful
When I log in to the MoaS application
And I search for the generated item in Local entities Items
Then the item has sorting decision "103 - Schiedam retouren" and dutiable status "No"
When I search for the generated item in Messages sent to eMagiz
Then the generated item has messages in Messages sent to eMagiz:
  | MessageType   | Target                           |
  | Kafka Message | nl.postnl.pnlecus.accp.sortdecs |
Then the eMagiz payload for target "nl.postnl.pnlecus.accp.sortdecs" matches:
  | JSON path         | Expected value   |
  | $.ItemId          | Generated ItemId |
  | $.SortingDecision | _103             |


# =====================================================================================
# T601KFYCOHandlingMarkItemAsOK
# =====================================================================================
  @T601KFYCOHandlingMarkItemAsOK
Scenario: Validate that an item can be marked as K-FYCO OK from K-FYCO handling
When I send a PREDES message with:
  | Item1IdPrefix | UA              |
  | Item1IdSuffix | US              |
  | PREDESPREFIX  | USLAXANLHAGICUN |
  | NumberOfItems | 1               |
Then the message API response is successful
And I send an ITMATT message with:
  | ItemIdPrefix                | UA                       |
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
  | ReceiverName                | ART Receiver name        |
  | ReceiverStreet              | Loire                    |
  | ReceiverHouseNumber         | 1                        |
  | ReceiverHouseNumberAddition |                          |
  | ReceiverPostCode            | 2491 AN                  |
  | ReceiverCity                | Den Haag                 |
  | ReceiverCountry             | NL                       |
  | ReceiverTelephone           | 3165738957               |
  | ReceiverEmail               | testreceiver@email.com   |
  | SenderName                  | ART Sender name two      |
  | SenderStreetAndNumber       | 1567 Broadway            |
  | SenderPostCode              | 10036                    |
  | SenderCity                  | New York                 |
  | SenderCountry               | US                       |
  | SenderTelephone             | 38957389                 |
  | SenderEmail                 | testsender@email.com     |
Then the message API response is successful
When I log in to the MoaS application
And I search for the generated item in "K-FYCO handling" Items
Then I can mark the item as "New K-FYCO"
When I search for the generated item in Messages sent to eMagiz
    Then the generated item has messages in Messages sent to eMagiz:
      | MessageType   | Target                          |
      | Kafka Message | nl.postnl.pnlecus.accp.sortdecs  |
      | Kafka Message | nl.postnl.pnlecus.accp.eventupd|
      | Kafka Message | nl.postnl.pnlecus.accp.sortdecs |
      | Kafka Message | nl.postnl.pnlecus.accp.sortdecs |
    Then the eMagiz payload for target "nl.postnl.pnlecus.accp.sortdecs" matches:
      | JSON path         | Expected value   |
      | $.ItemId          | Generated ItemId |
      | $.SortingDecision | _021             |
    Then the eMagiz payload for target "nl.postnl.pnlecus.accp.eventupd" at row 2 matches:
      | XPath                | Expected value   |
      | /ItemId              | Generated ItemId |
      | /ReceptacleId        | Generated ReceptacleId |
      | /Dutiable            | true           |
      | /OfficeLocation      | NLHAGI           |
      | /UserRole            | WPOL\MOAS        |
      | /Country             | US               |
      | /MailClass           | U                |
      | /BvA                 | 1200               |