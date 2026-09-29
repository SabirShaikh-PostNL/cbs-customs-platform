import { createBdd, DataTable } from 'playwright-bdd';
import { testWithPages } from '@/fixtures/pages';

const { When, Then } = createBdd(testWithPages);

When(
  'I navigate to Data Completion page and search item',
  async ({ dataCompletionPage, messageContext }) => {
    if (!messageContext.itemId) {
      throw new Error('No generated item is available for this scenario.');
    }

    await dataCompletionPage.navigateToDataCompletion();
    await dataCompletionPage.searchByItemId(messageContext.itemId);
  }
);

When(
  'I add the required Receivers address details on Data completion page',
  async ({ dataCompletionPage }, table: DataTable) => {
    await dataCompletionPage.fillAddressDetails(table.rowsHash());
  }
);

Then('the City name is {string}', async ({ dataCompletionPage }, expectedCity: string) => {
  await dataCompletionPage.verifyReceiverCity(expectedCity);
});

When(
  'I change the Receivers country to {string}',
  async ({ dataCompletionPage }, country: string) => {
    await dataCompletionPage.changeReceiverCountry(country);
  }
);

When('I mark the item as {string}', async ({ dataCompletionPage }, action: string) => {
  await dataCompletionPage.selectItemAction(action);
});

When(
  'I click on the {string} button',
  async ({ dataCompletionPage }, buttonName: string) => {
    await dataCompletionPage.clickActionButton(buttonName);
  }
);