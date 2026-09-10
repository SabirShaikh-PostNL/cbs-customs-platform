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


@T062Sorting017-Specials-BlacklistedReceiverAddresses
Scenario: Validate Specials sorting by blacklisted receiver address
    When I log in to the MoaS application
    And I navigate to setting Specials Criteria
    And I add Blacklisted address to Specials
      | Name   | Blacklisted Name       |
      | Company   | Blacklisted Receiver Company        |
      | Sender/Receiver   | Receiver        |
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
        | ContentPieceHSCode          | 950300                |
        | ContentPieceWeight          | 0.2                    |
        | ContentPieceNumberOfPieces  | 1                      |
        | ContentPieceValue           | 30.00                  |
        | ContentPieceCurrency        | USD                    |
        | ContentPieceOriginCountry   | US                     |
        | ContentPieceDescription     | Automated Test Stuff1  |
        | ReceiverName                | Blacklisted Name       |
        | ReceiverCompanyName         | Blacklisted Receiver Company |
        | ReceiverStreet              | Loire                  |
        | ReceiverHouseNumber         | 1                      |
        | ReceiverHouseNumberAddition |                        |
        | ReceiverPostCode            | 2491 AN                |
        | ReceiverCity                | Den Haag               |
        | ReceiverCountry             | NL                     |
        | ReceiverTelephone           | 3165738957             |
        | ReceiverEmail               | testreceiver@email.com |
        | SenderName                  | ART Sender name two    |
        | SenderCompanyName           | ART Sender Company     |
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
    And I delete the created blacklisted address


    @T063Sorting017-Specials-BlacklistedSenderAddresses
Scenario: Validate Specials sorting by blacklisted sender address
    When I log in to the MoaS application
    And I navigate to setting Specials Criteria
    And I add Blacklisted address to Specials
      | Name   | Blacklisted Name       |
      | Company   | Blacklisted Sender Company        |
      | Sender/Receiver   | Sender        |
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
        | ContentPieceHSCode          | 950300                |
        | ContentPieceWeight          | 0.2                    |
        | ContentPieceNumberOfPieces  | 1                      |
        | ContentPieceValue           | 30.00                  |
        | ContentPieceCurrency        | USD                    |
        | ContentPieceOriginCountry   | US                     |
        | ContentPieceDescription     | Automated Test Stuff1  |
        | ReceiverName                | ART Receiver      |
        | ReceiverCompanyName         | ART Receiver Company |
        | ReceiverStreet              | Loire                  |
        | ReceiverHouseNumber         | 1                      |
        | ReceiverHouseNumberAddition |                        |
        | ReceiverPostCode            | 2491 AN                |
        | ReceiverCity                | Den Haag               |
        | ReceiverCountry             | NL                     |
        | ReceiverTelephone           | 3165738957             |
        | ReceiverEmail               | testreceiver@email.com |
        | SenderName                  | Blacklisted Name   |
        | SenderCompanyName           | Blacklisted Sender Company    |
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
    And I delete the created blacklisted address

      @T064Sorting017-SpecialsTransportValueAbove300EuroTINA
  Scenario: Validate Specials sorting when transport costs are above 300 EUR
    When I log in to the MoaS application
    When I send a PREDES message with:
      | Item1IdPrefix | UA                |
      | Item1IdSuffix | US                |
      | PREDESPREFIX  | USLAXANLHAGICUN   |
      | NumberOfItems | 1                 |
    Then the message API response is successful
    And I send an ITMATT message with:
      | ItemIdPrefix                | UA                     |
      | ItemIdSuffix                | US                     |
      | TotalWeight                 | 0.2                    |
      | MailClass                   | E                      |
      | Gift                        | false                  |
      | TransportCosts              | 400                    |
      | TransportCurrency           | EUR                    |
      | OriginCountry               | US                     |
      | ContentPieceHSCode          | 950300                 |
      | ContentPieceWeight          | 0.2                    |
      | ContentPieceNumberOfPieces  | 1                      |
      | ContentPieceValue           | 300.00                 |
      | ContentPieceCurrency        | USD                    |
      | ContentPieceOriginCountry   | US                     |
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


      @T065Sorting017-SpecialsTransportValueAbove300EuroRICK
  Scenario: Validate Specials sorting when transport costs are above 300 EUR RICK
    When I log in to the MoaS application
    When I send a PREDES message with:
      | Item1IdPrefix | UA              |
      | Item1IdSuffix | US              |
      | PREDESPREFIX  | USLAXANLHAGICUN |
      | NumberOfItems | 1               |
    Then the message API response is successful
    And I send an ITMATT message with:
      | ItemIdPrefix                | UA                     |
      | ItemIdSuffix                | US                     |
      | TotalWeight                 | 0.2                    |
      | MailClass                   | U                      |
      | Gift                        | false                  |
      | TransportCosts              | 400                    |
      | TransportCurrency           | EUR                    |
      | OriginCountry               | US                     |
      | ContentPieceHSCode          | 950300                 |
      | ContentPieceWeight          | 0.2                    |
      | ContentPieceNumberOfPieces  | 1                      |
      | ContentPieceValue           | 30.00                  |
      | ContentPieceCurrency        | USD                    |
      | ContentPieceOriginCountry   | US                     |
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


      @T066Sorting017-SpecialsContentPieceTotalWeightAbove30KgRick
  Scenario: Validate Specials sorting when content piece total weight is above 30 KG
    When I log in to the MoaS application
    When I send a PREDES message with:
      | Item1IdPrefix | UA              |
      | Item1IdSuffix | US              |
      | PREDESPREFIX  | USLAXANLHAGICUN |
      | NumberOfItems | 1               |
    Then the message API response is successful
    And I send an ITMATT message with:
      | ItemIdPrefix                | UA                     |
      | ItemIdSuffix                | US                     |
      | TotalWeight | 31 |
      | MailClass                   | U                      |
      | Gift                        | false                  |
      | TransportCosts              | 100                    |
      | TransportCurrency           | EUR                    |
      | OriginCountry               | US                     |
      | ContentPieceHSCode          | 722410                 |
      | ContentPieceWeight          | 31                     |
      | ContentPieceNumberOfPieces  | 1                      |
      | ContentPieceValue           | 90.00                  |
      | ContentPieceCurrency        | USD                    |
      | ContentPieceOriginCountry   | US                     |
      | ContentPieceDescription     | Automated stuff        |
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


 @T067Sorting017-SpecialsContentPieceTotalWeightAbove30KgTINA
Scenario: Validate Specials sorting when content piece weight is above 30 KG
  When I log in to the MoaS application
  When I send a PREDES message with:
    | Item1IdPrefix | UA |
    | Item1IdSuffix | US |
    | PREDESPREFIX  | USLAXANLHAGICUN |
    | NumberOfItems | 1 |
  Then the message API response is successful
  And I send an ITMATT message with:
    | ItemIdPrefix               | UA                     |
    | ItemIdSuffix               | US                     |
        | TotalWeight | 31 |
    | MailClass                  | U                      |
    | Gift                       | false                  |
    | TransportCosts             | 100                    |
    | TransportCurrency          | EUR                    |
    | OriginCountry              | US                     |
    | ContentPieceHSCode         | 722410                 |
    | ContentPieceWeight         | 31                     |
    | ContentPieceNumberOfPieces | 1                      |
    | ContentPieceValue          | 200.00                 |
    | ContentPieceCurrency       | USD                    |
    | ContentPieceOriginCountry  | US                     |
    | ContentPieceDescription    | Automated stuff        |
    | ReceiverName               | ART Receiver name      |
    | ReceiverStreet             | Loire                  |
    | ReceiverHouseNumber        | 1                      |
    | ReceiverHouseNumberAddition|                        |
    | ReceiverPostCode           | 2491 AN                |
    | ReceiverCity               | Den Haag               |
    | ReceiverCountry            | NL                     |
    | ReceiverTelephone          | 3165738957             |
    | ReceiverEmail              | testreceiver@email.com |
    | SenderName                 | ART Sender name two    |
    | SenderStreetAndNumber      | 1567 Broadway          |
    | SenderPostCode             | 10036                  |
    | SenderCity                 | New York               |
    | SenderCountry              | US                     |
    | SenderTelephone            | 38957389               |
    | SenderEmail                | testsender@email.com   |
      Then the message API response is successful
  When I search for the generated item in Local entities Items
  Then the item has sorting decision "017 - Specials" and dutiable status "Yes"


    @T068Sorting017-SpecialsTotalWeightAbove30
Scenario: Validate Specials sorting when total weight is above 30 KG
When I log in to the MoaS application
When I send a PREDES message with:
  | Item1IdPrefix | UA |
  | Item1IdSuffix | US |
  | PREDESPREFIX  | USLAXANLHAGICUN |
  | NumberOfItems | 1 |
Then the message API response is successful
And I send an ITMATT message with:
  | ItemIdPrefix                | UA                     |
  | ItemIdSuffix                | US                     |
  | TotalWeight                 | 31                     |
  | MailClass                   | U                      |
  | Gift                        | false                  |
  | TransportCosts              | 100                    |
  | TransportCurrency           | EUR                    |
  | OriginCountry               | US                     |
  | ContentPieceHSCode          | 950300                 |
  | ContentPieceWeight          | 0.2                    |
  | ContentPieceNumberOfPieces  | 1                      |
  | ContentPieceValue           | 30.00                  |
  | ContentPieceCurrency        | USD                    |
  | ContentPieceOriginCountry   | US                     |
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