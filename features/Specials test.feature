Feature: Specials sorting

  @T060Sorting017-Specials017HSCode
  Scenario: Validate Specials sorting by HS code
    When I log in to the MoaS application
    And I navigate to setting Specials Criteria
    And I add HSCODE to Specials
      | Criterion   | 060490        |
      | Description | ANDERE MOSSEN |
    When I send a PREDES message with:
      | Item1IdPrefix | RL |
      | Item1IdSuffix | US |
      | PREDESPREFIX  | USDUBANLHAGICUN |
      | NumberOfItems | 1 |
    Then the message API response is successful
    And I send an ITMATT message with:
     | ItemIdPrefix                | RL                     |
        | ItemIdSuffix                | US                     |
        | TotalWeight                 | 0.2                    |
        | MailClass                   | U                      |
        | Gift                        | false                  |
        | TransportCosts              | 10.05                  |
        | TransportCurrency           | EUR                    |
        | OriginCountry               | US                     |
        | ContentPieceHSCode          | 060490                 |
        | ContentPieceWeight          | 0.2                    |
        | ContentPieceNumberOfPieces  | 1                      |
        | ContentPieceValue           | 24.00                  |
        | ContentPieceCurrency        | EUR                    |
        | ContentPieceOriginCountry   | ES                     |
        | ContentPieceDescription     | Automated Test Stuff1  |
        | ReceiverName                | ART Receiver name      |
        | ReceiverStreet              | Loire                  |
        | ReceiverHouseNumber         | 1                      |
        | ReceiverHouseNumberAddition |                        |
        | ReceiverPostCode            | 2491 AN                |
        | ReceiverCity                | Den Haag               |
        | ReceiverCountry             | NL                     |
        | ReceiverTelephone           | 3165738957             |
        | ReceiverEmail               | testreceiver@email.com |
        | SenderName                  | ART Sender name two    |
        | SenderStreetAndNumber       | 1567 Broadway          |
        | SenderPostCode              | 10036                  |
        | SenderCity                  | New York               |
        | SenderCountry               | US                     |
        | SenderTelephone             | 38957389               |
        | SenderEmail                 | testsender@email.com   |
    Then the message API response is successful
    When I search for the generated item in Local entities Items
    Then the item has sorting decision "017 - Specials" and dutiable status "Yes"
    When I navigate to setting Specials Criteria
    And I delete the created criteria


  @T061Sorting017-Specials017Keywords
  Scenario: Validate Specials sorting by keyword
    When I log in to the MoaS application
    And I navigate to setting Specials Criteria
    And I add Keyword to Specials
      | Keyword   | killer gorilla        |
    When I send a PREDES message with:
      | Item1IdPrefix | RL |
      | Item1IdSuffix | US |
      | PREDESPREFIX  | USDUBANLHAGICUN |
      | NumberOfItems | 1 |
    Then the message API response is successful
    And I send an ITMATT message with:
     | ItemIdPrefix                | RL                     |
        | ItemIdSuffix                | US                     |
        | TotalWeight                 | 0.2                    |
        | MailClass                   | U                      |
        | Gift                        | false                  |
        | TransportCosts              | 10.05                  |
        | TransportCurrency           | EUR                    |
        | OriginCountry               | US                     |
        | ContentPieceHSCode          | 640811051                |
        | ContentPieceWeight          | 0.2                    |
        | ContentPieceNumberOfPieces  | 1                      |
        | ContentPieceValue           | 24.00                  |
        | ContentPieceCurrency        | EUR                    |
        | ContentPieceOriginCountry   | US                     |
        | ContentPieceDescription     | KILLER GORILLA  |
        | ReceiverName                | ART Receiver name      |
        | ReceiverStreet              | Loire                  |
        | ReceiverHouseNumber         | 1                      |
        | ReceiverHouseNumberAddition |                        |
        | ReceiverPostCode            | 2491 AN                |
        | ReceiverCity                | Den Haag               |
        | ReceiverCountry             | NL                     |
        | ReceiverTelephone           | 3165738957             |
        | ReceiverEmail               | testreceiver@email.com |
        | SenderName                  | ART Sender name two    |
        | SenderStreetAndNumber       | 1567 Broadway          |
        | SenderPostCode              | 10036                  |
        | SenderCity                  | New York               |
        | SenderCountry               | US                     |
        | SenderTelephone             | 38957389               |
        | SenderEmail                 | testsender@email.com   |
    Then the message API response is successful
    When I search for the generated item in Local entities Items
    Then the item has sorting decision "004 - Data incomplete HS code" and dutiable status "Yes"
    When I navigate to setting Specials Criteria
    And I delete the created Specials Keyword
