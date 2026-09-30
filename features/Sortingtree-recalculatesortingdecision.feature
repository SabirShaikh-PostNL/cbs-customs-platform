Feature: Sorting Tree Verification Recalculate Sorting Decision

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



  @T091aStoreDataAndRecalculateTransit_Packet-SD025
  Scenario: Validate that the sorting tree recalculates the sorting decision to transit packet
    When I send a PREDES message with:
      | Item1IdPrefix | CT |
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
    Then the eMagiz payload for target "nl.postnl.pnlecus.accp.eventupd" matches:
      | XPath                | Expected value   |
      | /ItemId              | Generated ItemId |
      | /Dutiable            | false            |
      | /OfficeLocation      | NLHAGI           |
      | /UserRole            | WPOL\MOAS        |
      | /Country             | US               |
      | /MailClass           | U                |
      | /BvA                 | 76               |
      | /ActionReason        | E-10             |
      



      @T092StoreDataAndRecalculateWaitingForBvAResponse-SD016
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
  Then the item has sorting decision "021 - K-FyCo"
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
  Then the eMagiz payload for target "nl.postnl.pnlecus.accp.eventupd" matches:
    | XPath           | Expected value   |
    | /ItemId         | Generated ItemId |
    | /ReceptacleId   | Generated ReceptacleId |
    | /Dutiable       | true             |
    | /OfficeLocation | NLHAGI           |
    | /UserRole       | WPOL\MOAS        |
    | /Country        | US               |
    | /MailClass      | U                |
    | /BvA            | 1200             |