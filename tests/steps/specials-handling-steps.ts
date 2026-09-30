import { createBdd } from 'playwright-bdd';
import { testWithPages } from '@/fixtures/pages';

const { When, Then } = createBdd(testWithPages);

When(
  'I search for the generated item in Specials handling',
  async ({ messageContext, specialsHandlingPage }) => {
    if (!messageContext.itemId) {
      throw new Error('No generated item is available for this scenario.');
    }

    await specialsHandlingPage.searchByItemId(messageContext.itemId);
  }
);

When('I mark the item as no longer special via DC', async ({ specialsHandlingPage }) => {
  await specialsHandlingPage.markItemAsNoLongerSpecial();
});

Then(
  'the Specials handling confirmation says the item has sorting decision {string}',
  async ({ messageContext, specialsHandlingPage }, sortingDecision: string) => {
    if (!messageContext.itemId) {
      throw new Error('No generated item is available for this scenario.');
    }

    await specialsHandlingPage.verifyNoLongerSpecialConfirmation(
      messageContext.itemId,
      sortingDecision
    );
  }
);

Then('I accept the Specials handling confirmation', async ({ specialsHandlingPage }) => {
  await specialsHandlingPage.acceptInformationDialog();
});
