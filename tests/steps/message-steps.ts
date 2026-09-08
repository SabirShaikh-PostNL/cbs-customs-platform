import { expect } from '@playwright/test';
import { createBdd, DataTable } from 'playwright-bdd';
import { ItmattApi } from '@/api/itmatt-api';
import { PredesApi } from '@/api/predes-api';
import { testWithPages } from '@/fixtures/pages';
import { generateRandomNumber, generateS10Barcode } from '@/utils/generate-item-id';

const { When, Then } = createBdd(testWithPages);

When('I send an ITMATT message with:', async ({ request, messageContext, bddTestInfo }, table: DataTable) => {
  const data = table.rowsHash();
  const required = (name: string): string => {
    const value = data[name];
    if (value === undefined) {
      throw new Error(`Missing ITMATT test data field: ${name}`);
    }
    return value;
  };
  const escapeXml = (value: string): string =>
    value.replace(/[<>&'"]/g, character =>
      ({
        '<': '&lt;',
        '>': '&gt;',
        '&': '&amp;',
        "'": '&apos;',
        '"': '&quot;',
      })[character] ?? character
    );

  const itemId = generateS10Barcode(required('ItemIdPrefix'), required('ItemIdSuffix'));
  const xmlPayload = `<?xml version="1.0" encoding="UTF-8"?>
<Item><ItemId>${itemId}</ItemId><TotalWeight>${escapeXml(required('TotalWeight'))}</TotalWeight><MailClass>${escapeXml(required('MailClass'))}</MailClass><Gift>${escapeXml(required('Gift'))}</Gift><TransportCosts>${escapeXml(required('TransportCosts'))}</TransportCosts><TransportCurrency>${escapeXml(required('TransportCurrency'))}</TransportCurrency><OriginCountry>${escapeXml(required('OriginCountry'))}</OriginCountry><ContentPiece><HSCode>${escapeXml(required('ContentPieceHSCode'))}</HSCode><Weight>${escapeXml(required('ContentPieceWeight'))}</Weight><NumberOfPieces>${escapeXml(required('ContentPieceNumberOfPieces'))}</NumberOfPieces><Value>${escapeXml(required('ContentPieceValue'))}</Value><Currency>${escapeXml(required('ContentPieceCurrency'))}</Currency><OriginCountry>${escapeXml(required('ContentPieceOriginCountry'))}</OriginCountry><Description>${escapeXml(required('ContentPieceDescription'))}</Description></ContentPiece><ReceiverAddress><Name>${escapeXml(required('ReceiverName'))}</Name><Street>${escapeXml(required('ReceiverStreet'))}</Street><HouseNumber>${escapeXml(required('ReceiverHouseNumber'))}</HouseNumber><HouseNumberAddition>${escapeXml(required('ReceiverHouseNumberAddition'))}</HouseNumberAddition><PostCode>${escapeXml(required('ReceiverPostCode'))}</PostCode><City>${escapeXml(required('ReceiverCity'))}</City><Country>${escapeXml(required('ReceiverCountry'))}</Country></ReceiverAddress><ReceiverContactInformation><Telephone>${escapeXml(required('ReceiverTelephone'))}</Telephone><Email>${escapeXml(required('ReceiverEmail'))}</Email></ReceiverContactInformation><SenderAddress><Name>${escapeXml(required('SenderName'))}</Name><StreetAndNumber>${escapeXml(required('SenderStreetAndNumber'))}</StreetAndNumber><PostCode>${escapeXml(required('SenderPostCode'))}</PostCode><City>${escapeXml(required('SenderCity'))}</City><Country>${escapeXml(required('SenderCountry'))}</Country></SenderAddress><SenderContactInformation><Telephone>${escapeXml(required('SenderTelephone'))}</Telephone><Email>${escapeXml(required('SenderEmail'))}</Email></SenderContactInformation></Item>`;
  const response = await new ItmattApi(request).sendItmatt(xmlPayload);
  const responseBody = await response.text();

  await bddTestInfo.attach(`ITMATT request ${itemId}`, {
    body: xmlPayload,
    contentType: 'application/xml',
  });
  await bddTestInfo.attach(`ITMATT response ${itemId}`, {
    body: responseBody,
    contentType: 'text/plain',
  });

  messageContext.itemId = itemId;
  messageContext.itmattItemId = itemId;
  messageContext.responseStatus = response.status();
  messageContext.responseBody = responseBody;
});

When('I send a PREDES message with:', async ({ request, messageContext, bddTestInfo }, table: DataTable) => {
  const data = table.rowsHash();
  const required = (name: string): string => {
    const value = data[name];
    if (value === undefined || value.trim() === '') {
      throw new Error(`Missing PREDES test data field: ${name}`);
    }
    return value.trim();
  };
  const itemCount = Number(required('NumberOfItems'));
  if (!Number.isInteger(itemCount) || itemCount < 1 || itemCount > 3) {
    throw new Error('PREDES NumberOfItems must be an integer from 1 to 3.');
  }

  const itemIds = Array.from({ length: itemCount }, (_, index) => {
    const itemNumber = index + 1;
    return generateS10Barcode(
      required(`Item${itemNumber}IdPrefix`),
      required(`Item${itemNumber}IdSuffix`)
    );
  });
  const payload = {
    PWS_Receptacle: {
      ReceptacleId: `${required('PREDESPREFIX')}${generateRandomNumber(14)}`,
      Item: itemIds.map(itemId => ({ ItemId: itemId })),
    },
  };
  const response = await new PredesApi(request).sendPredes(payload);
  const responseBody = await response.text();

  await bddTestInfo.attach(`PREDES request ${itemIds[0]}`, {
    body: JSON.stringify(payload, null, 2),
    contentType: 'application/json',
  });
  await bddTestInfo.attach(`PREDES response ${itemIds[0]}`, {
    body: responseBody,
    contentType: 'text/plain',
  });

  messageContext.itemId = itemIds[0];
  messageContext.predesItemIds = itemIds;
  messageContext.responseStatus = response.status();
  messageContext.responseBody = responseBody;
});

Then('the message API response is successful', async ({ messageContext }) => {
  expect(messageContext.responseStatus, messageContext.responseBody).toBe(200);
});

Then('I log in to the MoaS application', async ({ loginPage }) => {
  await loginPage.navigate();
  await loginPage.login();
  await loginPage.verifyLoggedIn();
});

When(
  'I search for the generated item in Local entities Items',
  async ({ localEntitiesItemsPage, messageContext }) => {
    if (!messageContext.itemId) {
      throw new Error('No generated item is available for this scenario.');
    }
    await localEntitiesItemsPage.navigateToLocalEntitiesItems();
    await localEntitiesItemsPage.searchItemsByItemId(messageContext.itemId);
  }
);

Then(
  'the item has sorting decision {string} and dutiable status {string}',
  async ({ localEntitiesItemsPage }, sortingDecision: string, dutiable: 'Yes' | 'No') => {
    await localEntitiesItemsPage.verifyItemSortingAndDutiable(sortingDecision, dutiable);
  }
);

When(
  'I search for the generated item in Processed requests',
  async ({ messageContext, processedRequestsPage }) => {
    if (!messageContext.itemId) {
      throw new Error('No generated item is available for this scenario.');
    }
    await processedRequestsPage.navigateToProcessedRequests();
    await processedRequestsPage.searchByPayload(messageContext.itemId);
  }
);

Then(
  'the processed request has message name {string} and flags:',
  async ({ messageContext, processedRequestsPage }, messageName: string, table: DataTable) => {
    if (!messageContext.itemId) {
      throw new Error('No generated item is available for this scenario.');
    }
    const flags = table.rowsHash() as Record<string, 'Yes' | 'No'>;
    await processedRequestsPage.verifyProcessedRequest(
      messageContext.itemId,
      messageName,
      flags['Is processed'],
      flags['Is error'],
      flags['Is failed']
    );
  }
);
