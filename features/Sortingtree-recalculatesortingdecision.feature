Feature: Sorting Tree Verification Recalculate Sorting Decision


# ============================================================================================================================================================================
# T091StoreDataAndRecalculateSendToExport-SD024
# ============================================================================================================================================================================
  @T091StoreDataAndRecalculateSendToExport-SD024
  Scenario: Validate that the sorting tree recalculates the sorting decision when a new item is added to the shipment
    When I send a PREDES message with:
      | Item1IdPrefix | CT |
      | Item1IdSuffix | US |
      | PREDESPREFIX  | USLAXANLHAGICCN |
      | NumberOfItems | 1 |
    Then the message API response is successful
    And I send an ITMATT message with:
      | ItemIdPrefix                | CT                       |
      | ItemIdSuffix                | US                       |
      | TotalWeight                 | 0.2                      |
      | MailClass                   | C                        |
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
      | SenderTelephone             | 38957389                 |
      | SenderEmail                 | testsender@email.com     |
    Then the message API response is successful
    When I log in to the MoaS application
    And I navigate to Data Completion page and search item
    And I add the required Receivers address details on Data completion page
      | Country               | NL      |
      | State or province     |         |
      | Postal code           | 2491 AN |
      | House number          | 1       |
      | House number addition |         |
      | Street                |         |
      | City                  |         |
    Then the City name is "'S-GRAVENHAGE"
    And I change the Receivers country to "DE"
    And I mark the item as "Send to export"
    And I click on the "Store data and recalculate sorting decision" button
    When I search for the generated item in Local entities Items
    Then the item has sorting decision "024 - Transit Parcel"
    When I search for the generated item in Messages sent to eMagiz
    Then the generated item has messages in Messages sent to eMagiz:
      | MessageType   | Target                                |
      | Kafka Message | nl.postnl.pnlecus.accp.prlrtms       |
      | Kafka Message | nl.postnl.pnlecus.accp.sortdecs      |
      | Kafka Message | nl.postnl.pnlecus.accp.sortdecs      |
    Then the eMagiz payload for target "nl.postnl.pnlecus.accp.sortdecs" matches:
      | JSON path         | Expected value   |
      | $.ItemId          | Generated ItemId |
      | $.SortingDecision | _024             |
    Then the eMagiz payload for target "nl.postnl.pnlecus.accp.prlrtms" matches:
      | JSON path                                                           | Expected value  |
      | $.Message.Sender                                                    | MoaS Import     |
      | $.Message.Item.IdentificationNumber                                 | Generated ItemId |
      | $.Message.Item.ItemOwner                                            | Postal Operator |
      | $.Message.Item.Consignor.Address[0].Country                         | US              |
      | $.Message.Item.Shipper.Address[0].Country                           | US              |
      | $.Message.Item.Consignee.Address[0].Country                         | DE              |
      | $.Message.Item.Weight[0].Weight                                     | "0.2"           |
      | $.Message.Item.Weight[0].Unit                                       | kg              |
      | $.Message.Item.Weight[0].Type                                       | Original        |
      | $.Message.Item.PostalTransit                                        | true            |
      | $.Message.Item.Declaration[0].Type                                  | ICS2            |
      | $.Message.Item.Declaration[0]['DeclarationStatus'][0].Type           | Cleared         |


# ============================================================================================================================================================================
# T091aStoreDataAndRecalculateTransit_Packet-SD025
# ============================================================================================================================================================================
  @T091aStoreDataAndRecalculateTransit_Packet-SD025
  Scenario: Validate that the sorting tree recalculates the sorting decision to transit packet
    When I send a PREDES message with:
      | Item1IdPrefix | AB |
      | Item1IdSuffix | US |
      | PREDESPREFIX  | USLAXANLHAGICCN |
      | NumberOfItems | 1 |
    Then the message API response is successful
    And I send an ITMATT message with:
      | ItemIdPrefix                | AB                       |
      | ItemIdSuffix                | US                       |
      | TotalWeight                 | 0.2                      |
      | MailClass                   | C                        |
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
      | SenderTelephone             | 38957389                 |
      | SenderEmail                 | testsender@email.com     |
    Then the message API response is successful
    When I log in to the MoaS application
    And I navigate to Data Completion page and search item
    And I add the required Receivers address details on Data completion page
      | Country               | NL      |
      | State or province     |         |
      | Postal code           | 2491 AN |
      | House number          | 1       |
      | House number addition |         |
      | Street                |         |
      | City                  |         |
    Then the City name is "'S-GRAVENHAGE"
    And I mark the item as "Mark item as Rejected"
    And I click on the "Store data and recalculate sorting decision" button
    When I search for the generated item in Local entities Items
    Then the item has sorting decision "025 - Transit Packet"
    When I search for the generated item in Messages sent to eMagiz
    Then the generated item has messages in Messages sent to eMagiz:
      | MessageType   | Target                          |
      | Kafka Message | nl.postnl.pnlecus.accp.sortdecs  |
      | Kafka Message | nl.postnl.pnlecus.accp.eventupd|
      | Kafka Message | nl.postnl.pnlecus.accp.sortdecs |
    Then the eMagiz payload for target "nl.postnl.pnlecus.accp.sortdecs" matches:
      | JSON path         | Expected value   |
      | $.ItemId          | Generated ItemId |
      | $.SortingDecision | _025             |
    Then the eMagiz payload for target "nl.postnl.pnlecus.accp.eventupd" at row 2 matches:
      | XPath                | Expected value   |
      | /ItemId              | Generated ItemId |
      | /ReceptacleId        | Generated ReceptacleId |
      | /Dutiable            | false            |
      | /OfficeLocation      | NLHAGI           |
      | /UserRole            | WPOL\MOAS        |
      | /Country             | US               |
      | /MailClass           | C                |
      | /BvA                 | 76               |
      | /ActionReason        | E-10             |
      


# ============================================================================================================================================================================
# T092StoreDataAndRecalculateSendToBVA-SD016
# ============================================================================================================================================================================
  @T092StoreDataAndRecalculateSendToBVA-SD016
Scenario: Validate that the sorting tree recalculates the sorting decision to waiting for BvA response
  When I send a PREDES message with:
    | Item1IdPrefix | RL                |
    | Item1IdSuffix | US                |
    | PREDESPREFIX  | USDUBANLHAGICUN   |
    | NumberOfItems | 1                 |
  Then the message API response is successful
  And I send an ITMATT message with:
    | ItemIdPrefix                 | RL                       |
    | ItemIdSuffix                 | US                       |
    | TotalWeight                  | 0.2                      |
    | MailClass                    | A                        |
    | Gift                         | false                    |
    | TransportCosts               | 10.05                    |
    | TransportCurrency            | EUR                      |
    | OriginCountry                | US                       |
    | ContentPieceHSCode           | 950300                   |
    | ContentPieceWeight           | 0.2                      |
    | ContentPieceNumberOfPieces   | 1                        |
    | ContentPieceValue            | 300.00                   |
    | ContentPieceCurrency         | USD                      |
    | ContentPieceOriginCountry    | US                       |
    | ContentPieceDescription      | Automated Test Stuff1    |
    | ReceiverName                 | ART Receiver name no hnr |
    | ReceiverStreet               |                          |
    | ReceiverHouseNumber          |                          |
    | ReceiverHouseNumberAddition  |                          |
    | ReceiverPostCode             |                          |
    | ReceiverCity                 | Den Haag                 |
    | ReceiverCountry              | NL                       |
    | ReceiverTelephone            | 3165738957               |
    | ReceiverEmail                | testreceiver@email.com   |
    | SenderName                   | ART Sender name two      |
    | SenderStreetAndNumber        | 1567 Broadway            |
    | SenderPostCode               | 10036                    |
    | SenderCity                   | New York                 |
    | SenderCountry                | US                       |
    | SenderTelephone              | 38957389                 |
    | SenderEmail                  | testsender@email.com     |
  Then the message API response is successful
  When I log in to the MoaS application
  And I navigate to Data Completion page and search item
  And I add the required Receivers address details on Data completion page
    | Country               | NL      |
    | State or province     |         |
    | Postal code           | 2491 AN |
    | House number          | 1       |
    | House number addition |         |
    | Street                |         |
    | City                  |         |
  Then the City name is "'S-GRAVENHAGE"
  And I mark the item as "Mark as BVA"
  And I provide BVA reason as "Marking it BVA for Testing"
  And I click on the "Store data and recalculate sorting decision" button
  When I search for the generated item in Local entities Items
  Then the item has sorting decision "016 - Waiting for BvA response"
  When I search for the generated item in Messages sent to eMagiz
  Then the generated item has messages in Messages sent to eMagiz:
    | MessageType   | Target                            |
    | Kafka Message | nl.postnl.pnlecus.accp.sortdecs  |
    | Kafka Message | nl.postnl.pnlecus.accp.eventupd  |
    | Kafka Message | nl.postnl.pnlecus.accp.sortdecs  |
  Then the eMagiz payload for target "nl.postnl.pnlecus.accp.sortdecs" matches:
    | JSON path         | Expected value   |
    | $.ItemId          | Generated ItemId |
    | $.SortingDecision | _016             |
  Then the eMagiz payload for target "nl.postnl.pnlecus.accp.eventupd" matches:
    | XPath                                           | Expected value          |
    | /BvAUpdate/ItemId                               | Generated ItemId        |
    | /BvAUpdate/Dutiable                             | true                    |
    | /BvAUpdate/OfficeLocation                       | NLHAGI                  |
    | /BvAUpdate/UserRole                             | WPOL\MOAS               |
    | /BvAUpdate/Country                              | US                      |
    | /BvAUpdate/MailClass                            | U                       |
    | /BvAUpdate/BvA                                  | 1102                    |
    | /BvAUpdate/RetentionReasonCd                    | 54                      |
    | /BvAUpdate/CustomsOfficeCd                      | NLHAGI                  |
    | /BvAUpdate/CustomsOfficeTypeCd                  | OE                      |



    @T093StoreDataAndRecalculateSendToKFycoFromSD005-SD021



# ============================================================================================================================================================================
# T093StoreDataAndRecalculateSendToKFycoFromSD005-SD021
# ============================================================================================================================================================================
  @T093StoreDataAndRecalculateSendToKFycoFromSD005-SD021
Scenario: Validate that the sorting tree recalculates the sorting decision to K-FyCo
  When I send a PREDES message with:
    | Item1IdPrefix | RL              |
    | Item1IdSuffix | US              |
    | PREDESPREFIX  | USDUBANLHAGICUN |
    | NumberOfItems | 1               |
  Then the message API response is successful
  And I send an ITMATT message with:
    | ItemIdPrefix                | RL                       |
    | ItemIdSuffix                | US                       |
    | TotalWeight                 | 0.2                      |
    | MailClass                   | A                        |
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
    | SenderTelephone             | 38957389                 |
    | SenderEmail                 | testsender@email.com     |
  Then the message API response is successful
  When I log in to the MoaS application
  And I navigate to Data Completion page and search item
  And I add the required Receivers address details on Data completion page
    | Country               | NL      |
    | State or province     |         |
    | Postal code           | 2491 AN |
    | House number          | 1       |
    | House number addition |         |
    | Street                |         |
    | City                  |         |
  Then the City name is "'S-GRAVENHAGE"
  And I mark the item as "Mark as K-FyCo"
  And I click on the "Store data and recalculate sorting decision" button
  When I search for the generated item in Local entities Items
  Then the item has sorting decision "021 - K-FYCO"
  When I search for the generated item in Messages sent to eMagiz
  Then the generated item has messages in Messages sent to eMagiz:
    | MessageType   | Target                           |
    | Kafka Message | nl.postnl.pnlecus.accp.sortdecs |
    | Kafka Message | nl.postnl.pnlecus.accp.eventupd |
    | Kafka Message | nl.postnl.pnlecus.accp.sortdecs |
  Then the eMagiz payload for target "nl.postnl.pnlecus.accp.sortdecs" matches:
    | JSON path         | Expected value   |
    | $.ItemId          | Generated ItemId |
    | $.SortingDecision | _021             |
  Then the eMagiz payload for target "nl.postnl.pnlecus.accp.eventupd" at row 2 matches:
    | XPath           | Expected value   |
    | /ItemId         | Generated ItemId |
    | /Dutiable       | true             |
    | /OfficeLocation | NLHAGI           |
    | /UserRole       | WPOL\MOAS        |
    | /Country        | US               |
    | /MailClass      | U                |
    | /BvA            | 1200             |



# ============================================================================================================================================================================
# T094bStoreDataAndRecalculateSendToKFycoFromSD013-SD021
# ============================================================================================================================================================================
@T094bStoreDataAndRecalculateSendToKFycoFromSD013-SD021
Scenario: Validate that the sorting tree recalculates the sorting decision to K-FYCO from SD013
When I send a PREDES message with:
  | Item1IdPrefix | RL              |
  | Item1IdSuffix | ES              |
  | PREDESPREFIX  | ESMADBNLHAGIAUX |
  | NumberOfItems | 1               |
Then the message API response is successful
When I send an ITMATT message with:
  | ItemIdPrefix                | RL                    |
  | ItemIdSuffix                | ES                    |
  | TotalWeight                 | 0.2                   |
  | MailClass                   | U                     |
  | Gift                        | true                  |
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
  | ReceiverEmail               | testreceiver@email.com |
  | SenderName                  | ART Sender name       |
  | SenderStreetAndNumber       | Teststreet 11         |
  | SenderPostCode              | 08001                 |
  | SenderCity                  | Barcelona             |
  | SenderCountry               | ES                    |
  | SenderTelephone             | 38957389              |
  | SenderEmail                 | testsender@email.com  |
Then the message API response is successful
When I log in to the MoaS application
And I navigate to Data Completion page and search item
And I mark the item as "Mark as K-FyCo"
And I click on the "Store data and recalculate sorting decision" button
When I search for the generated item in Local entities Items
Then the item has sorting decision "021 - K-FYCO"
When I search for the generated item in Messages sent to eMagiz
Then the generated item has messages in Messages sent to eMagiz:
  | MessageType   | Target                           |
  | Kafka Message | nl.postnl.pnlecus.accp.sortdecs |
  | Kafka Message | nl.postnl.pnlecus.accp.eventupd |
  | Kafka Message | nl.postnl.pnlecus.accp.sortdecs |
Then the eMagiz payload for target "nl.postnl.pnlecus.accp.sortdecs" matches:
  | JSON path         | Expected value   |
  | $.ItemId          | Generated ItemId |
  | $.SortingDecision | _021             |
Then the eMagiz payload for target "nl.postnl.pnlecus.accp.eventupd" at row 2 matches:
  | XPath           | Expected value         |
  | /ItemId         | Generated ItemId       |
  | /ReceptacleId   | Generated ReceptacleId |
  | /Dutiable       | false                  |
  | /OfficeLocation | NLHAGI                 |
  | /UserRole       | WPOL\MOAS              |
  | /Country        | ES                     |
  | /MailClass      | U                      |
  | /BvA            | 1200                   |


# ============================================================================================================================================================================
# T095StoreDataAndRecalculateSendToNonBVAFromSD016-SD008
# ============================================================================================================================================================================
@T095StoreDataAndRecalculateSendToNonBVAFromSD016-SD008
Scenario: Validate that the sorting tree recalculates the sorting decision to waiting for BvA response with BvA reason
When I send a PREDES message with:
  | Item1IdPrefix | RL              |
  | Item1IdSuffix | US              |
  | PREDESPREFIX  | USDUBANLHAGICUN |
  | NumberOfItems | 1               |
Then the message API response is successful
And I send an ITMATT message with:
  | ItemIdPrefix                | RL                       |
  | ItemIdSuffix                | US                       |
  | TotalWeight                 | 0.2                      |
  | MailClass                   | A                        |
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
  | SenderTelephone             | 38957389                 |
  | SenderEmail                 | testsender@email.com     |
Then the message API response is successful
When I log in to the MoaS application
And I navigate to Data Completion page and search item
And I add the required Receivers address details on Data completion page
  | Country               | NL      |
  | State or province     |         |
  | Postal code           | 2491 AN |
  | House number          | 1       |
  | House number addition |         |
  | Street                |         |
  | City                  |         |
Then the City name is "'S-GRAVENHAGE"
And I mark the item as "Mark as BVA"
And I provide BVA reason as "Marking it BVA for Testing"
And I click on the "Store data and recalculate sorting decision" button
And I navigate to Data Completion page and search item
And I click on the "Store data and recalculate sorting decision" button
When I search for the generated item in Local entities Items
Then the item has sorting decision "008 - TINA station" and dutiable status "Yes"
When I search for the generated item in Messages sent to eMagiz
Then the generated item has messages in Messages sent to eMagiz:
  | MessageType   | Target                           |
  | Kafka Message | nl.postnl.pnlecus.accp.sortdecs |
  | Kafka Message | nl.postnl.pnlecus.accp.sortdecs |
  | Kafka Message | nl.postnl.pnlecus.accp.eventupd |
  | Kafka Message | nl.postnl.pnlecus.accp.sortdecs |
Then the eMagiz payload for target "nl.postnl.pnlecus.accp.sortdecs" matches:
  | JSON path         | Expected value   |
  | $.ItemId          | Generated ItemId |
  | $.SortingDecision | _008             |
Then the eMagiz payload for target "nl.postnl.pnlecus.accp.sortdecs" at row 2 matches:
  | JSON path         | Expected value   |
  | $.ItemId          | Generated ItemId |
  | $.SortingDecision | _016             |
Then the eMagiz payload for target "nl.postnl.pnlecus.accp.eventupd" at row 3 matches:
  | XPath                  | Expected value         |
  | /ItemId                | Generated ItemId       |
  | /ReceptacleId          | Generated ReceptacleId |
  | /Dutiable              | true                   |
  | /OfficeLocation        | NLHAGI                 |
  | /UserRole              | WPOL\MOAS              |
  | /Country               | US                     |
  | /MailClass             | U                      |
  | /BvA                   | 1102                   |
  | /RetentionReasonCd     | 54                     |
  | /CustomsOfficeCd       | NLHAGI                 |



# ============================================================================================================================================================================
# T096StoreDataAndRecalculateDocumentToPNP-SD013
# ============================================================================================================================================================================
@T096StoreDataAndRecalculateDocumentToPNP-SD013
Scenario: Validate that the sorting tree recalculates the sorting decision to PNP after marking item as Document
When I send a PREDES message with:
  | Item1IdPrefix | LX              |
  | Item1IdSuffix | US              |
  | PREDESPREFIX  | USDUBANLHAGICUN |
  | NumberOfItems | 1               |
Then the message API response is successful
And I send an ITMATT message with:
  | ItemIdPrefix                | LX                       |
  | ItemIdSuffix                | US                       |
  | TotalWeight                 | 0.2                      |
  | MailClass                   | A                        |
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
  | SenderTelephone             | 38957389                 |
  | SenderEmail                 | testsender@email.com     |
Then the message API response is successful
When I log in to the MoaS application
And I navigate to Data Completion page and search item
And I add the required Receivers address details on Data completion page
  | Country               | NL      |
  | State or province     |         |
  | Postal code           | 2491 AN |
  | House number          | 1       |
  | House number addition |         |
  | Street                |         |
  | City                  |         |
Then the City name is "'S-GRAVENHAGE"
And I mark the item as "mark item as 'Document'"
And I click on the "Store data and recalculate sorting decision" button
When I search for the generated item in Local entities Items
Then the item has sorting decision "013 - PNP" and dutiable status "No"
When I search for the generated item in Messages sent to eMagiz
Then the generated item has messages in Messages sent to eMagiz:
  | MessageType   | Target                           |
  | Kafka Message | nl.postnl.pnlecus.accp.sortdecs |
  | Kafka Message | nl.postnl.pnlecus.accp.eventupd |
  | Kafka Message | nl.postnl.pnlecus.accp.sortdecs |
Then the eMagiz payload for target "nl.postnl.pnlecus.accp.sortdecs" matches:
  | JSON path         | Expected value   |
  | $.ItemId          | Generated ItemId |
  | $.SortingDecision | _013             |
Then the eMagiz payload for target "nl.postnl.pnlecus.accp.eventupd" at row 2 matches:
  | XPath           | Expected value         |
  | /ItemId         | Generated ItemId       |
  | /ReceptacleId   | Generated ReceptacleId |
  | /Dutiable       | false                  |
  | /OfficeLocation | NLHAGI                 |
  | /UserRole       | WPOL\MOAS              |
  | /Country        | US                     |
  | /MailClass      | U                      |
  | /BvA            | 1243                   |



# ============================================================================================================================================================================
# T097StoreDataAndRecalculateSendToWaitingForCustomsResponseSD009
# ============================================================================================================================================================================
@T097StoreDataAndRecalculateSendToWaitingForCustomsResponseSD009
Scenario: Validate recalculation from Send to Export (SD005) to Waiting for Customs Response (SD009) for an NL destination item with value below 45 after marking the item as a gift
When I send a PREDES message with:
  | Item1IdPrefix | RL              |
  | Item1IdSuffix | US              |
  | PREDESPREFIX  | USDUBANLHAGICUN |
  | NumberOfItems | 1               |
Then the message API response is successful
And I send an ITMATT message with:
  | ItemIdPrefix                | RL                       |
  | ItemIdSuffix                | US                       |
  | TotalWeight                 | 0.2                      |
  | MailClass                   | A                        |
  | Gift                        | false                    |
  | TransportCosts              | 10.05                    |
  | TransportCurrency           | EUR                      |
  | OriginCountry               | US                       |
  | ContentPieceHSCode          | 950300                   |
  | ContentPieceWeight          | 0.2                      |
  | ContentPieceNumberOfPieces  | 1                        |
  | ContentPieceValue           | 30.00                    |
  | ContentPieceCurrency        | VND                      |
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
  | SenderTelephone             | 38957389                 |
  | SenderEmail                 | testsender@email.com     |
Then the message API response is successful
When I log in to the MoaS application
And I navigate to Data Completion page and search item
And I add the required Receivers address details on Data completion page
  | Country               | NL      |
  | State or province     |         |
  | Postal code           | 2491 AN |
  | House number          | 1       |
  | House number addition |         |
  | Street                |         |
  | City                  |         |
Then the City name is "'S-GRAVENHAGE"
And I mark the item as "Is gift - mark item as a gift"
And I click on the "Store data and recalculate sorting decision" button
When I search for the generated item in Local entities Items
Then the item has sorting decision "009 - Waiting for customs response" and dutiable status "Yes"
When I search for the generated item in Messages sent to eMagiz
Then the generated item has messages in Messages sent to eMagiz:
  | MessageType   | Target                              |
  | Kafka Message | nl.postnl.pnlecus.accp.sortdecs    |
  | Kafka Message | nl.postnl.pnlecus.accp.dclrtnts       |
  | Kafka Message | nl.postnl.pnlecus.accp.sortdecs    |
Then the eMagiz payload for target "nl.postnl.pnlecus.accp.sortdecs" matches:
  | JSON path         | Expected value   |
  | $.ItemId          | Generated ItemId |
  | $.SortingDecision | _009             |
Then the eMagiz payload for target "nl.postnl.pnlecus.accp.dclrtnts" at row 2 matches:
  | JSON path            | Expected value         |
  | $.ItemId             | Generated ItemId       |
  | $.Mailclass          | U                      |
  | $.Gift               | true                   |
  | $.Currency           | EUR                    |
  | $.PaymentMethod      | Epayment               |
  | $.TransportCosts     | 10.05                  |
  | $.TransportCurrency  | EUR                    |
  | $.IsCommercial       | false                  |



# ============================================================================================================================================================================
# T098StoreDataAndRecalculateSendToNonDutiable-SD030orSD008
# ============================================================================================================================================================================


# ============================================================================================================================================================================
# T099StoreDataAndRecalculateSendToSpecials-SD005-SD017
# ============================================================================================================================================================================

@T099StoreDataAndRecalculateSendToSpecials-SD005-SD017
Scenario: Validate recalculation to Specials (SD017) after setting the item to Special
When I send a PREDES message with:
  | Item1IdPrefix | RL              |
  | Item1IdSuffix | US              |
  | PREDESPREFIX  | USDUBANLHAGICUN |
  | NumberOfItems | 1               |
Then the message API response is successful
And I send an ITMATT message with:
  | ItemIdPrefix                | RL                       |
  | ItemIdSuffix                | US                       |
  | TotalWeight                 | 0.2                      |
  | MailClass                   | A                        |
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
  | SenderTelephone             | 38957389                 |
  | SenderEmail                 | testsender@email.com     |
Then the message API response is successful
When I log in to the MoaS application
And I navigate to Data Completion page and search item
And I mark the item as "Set item to 'Special'"
And I click on the "Store data and recalculate sorting decision" button
When I search for the generated item in Local entities Items
Then the item has sorting decision "017 - Specials"
When I search for the generated item in Messages sent to eMagiz
Then the generated item has messages in Messages sent to eMagiz:
  | MessageType   | Target                           |
  | Kafka Message | nl.postnl.pnlecus.accp.sortdecs |
  | Kafka Message | nl.postnl.pnlecus.accp.sortdecs |
Then the eMagiz payload for target "nl.postnl.pnlecus.accp.sortdecs" matches:
  | JSON path         | Expected value   |
  | $.ItemId          | Generated ItemId |
  | $.SortingDecision | _017             |
When I search for the generated item in Specials handling
And I mark the item as no longer special via DC
Then the Specials handling confirmation says the item has sorting decision "_005"
And I accept the Specials handling confirmation

# ============================================================================================================================================================================
# T099aStoreDataAndRecalculateSendFromGiftToNonGiftromSD005-SD009
# ============================================================================================================================================================================

@T099aStoreDataAndRecalculateSendFromGiftToNonGiftromSD005-SD009
Scenario: Validate recalculation from Send to Export (SD005) to Waiting for Customs Response (SD009) after changing an item from Gift to Non Gift
When I send a PREDES message with:
  | Item1IdPrefix | RL              |
  | Item1IdSuffix | US              |
  | PREDESPREFIX  | USDUBANLHAGICUN |
  | NumberOfItems | 1               |
Then the message API response is successful
And I send an ITMATT message with:
  | ItemIdPrefix                | RL                       |
  | ItemIdSuffix                | US                       |
  | TotalWeight                 | 0.2                      |
  | MailClass                   | A                        |
  | Gift                        | true                     |
  | TransportCosts              | 10.05                    |
  | TransportCurrency           | EUR                      |
  | OriginCountry               | US                       |
  | ContentPieceHSCode          | 950300                   |
  | ContentPieceWeight          | 0.2                      |
  | ContentPieceNumberOfPieces  | 1                        |
  | ContentPieceValue           | 30.00                    |
  | ContentPieceCurrency        | VND                      |
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
  | SenderTelephone             | 38957389                 |
  | SenderEmail                 | testsender@email.com     |
Then the message API response is successful
When I log in to the MoaS application
And I navigate to Data Completion page and search item
And I add the required Receivers address details on Data completion page
  | Country               | NL      |
  | State or province     |         |
  | Postal code           | 2491 AN |
  | House number          | 1       |
  | House number addition |         |
  | Street                |         |
  | City                  |         |
Then the City name is "'S-GRAVENHAGE"
And I mark the item as "No Gift - Mark item as Non Gift"
And I click on the "Store data and recalculate sorting decision" button
When I search for the generated item in Local entities Items
Then the item has sorting decision "009 - Waiting for customs response"
When I search for the generated item in Messages sent to eMagiz
Then the generated item has messages in Messages sent to eMagiz:
  | MessageType   | Target                               |
  | Kafka Message | nl.postnl.pnlecus.accp.sortdecs      |
  | Kafka Message | nl.postnl.pnlecus.accp.dclrtnts      |
  | Kafka Message | nl.postnl.pnlecus.accp.sortdecs      |
Then the eMagiz payload for target "nl.postnl.pnlecus.accp.sortdecs" matches:
  | JSON path         | Expected value   |
  | $.ItemId          | Generated ItemId |
  | $.SortingDecision | _009             |
Then the eMagiz payload for target "nl.postnl.pnlecus.accp.dclrtnts" at row 2 matches:
  | JSON path           | Expected value   |
  | $.ItemId            | Generated ItemId |
  | $.Mailclass         | U                |
  | $.Gift              | false             |
  | $.Currency          | EUR              |
  | $.PaymentMethod     | Epayment         |
  | $.TransportCosts    | 10.05            |
  | $.TransportCurrency | EUR              |
  | $.IsCommercial      | false            |