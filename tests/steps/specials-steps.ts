import { createBdd, DataTable } from 'playwright-bdd';
import { testWithPages } from '@/fixtures/pages';

const { When } = createBdd(testWithPages);

When('I navigate to setting Specials Criteria', async ({ specialsCriteriaPage }) => {
  await specialsCriteriaPage.navigateToSpecialsCriteria();
});

When('I add HSCODE to Specials', async ({ specialsCriteriaPage }, table: DataTable) => {
  const data = table.rowsHash();
  const criterion = data['Criterion'];
  const description = data['Description'];

  if (criterion === undefined || description === undefined) {
    throw new Error('Specials criterion data must include Criterion and Description.');
  }

  await specialsCriteriaPage.addHsCodeCriterion(criterion, description);
});

When('I delete the created criteria', async ({ specialsCriteriaPage }) => {
  await specialsCriteriaPage.deleteCreatedCriterion();
});

When('I add Keyword to Specials', async ({ specialsCriteriaPage }, table: DataTable) => {
  const data = table.rowsHash();
  const keyword = data['Keyword'];

  if (keyword === undefined || keyword.trim() === '') {
    throw new Error('Specials keyword data must include Keyword.');
  }

  await specialsCriteriaPage.addKeyword(keyword.trim());
});

When('I delete the created Specials Keyword', async ({ specialsCriteriaPage }) => {
  await specialsCriteriaPage.deleteCreatedKeyword();
});

When(
  'I add Blacklisted address to Specials',
  async ({ specialsCriteriaPage, messageContext }, dataTable: DataTable) => {
    const data = dataTable.rowsHash();
    const name = data['Name'];
    const company = data['Company'];
    const senderOrReceiver = data['Sender/Receiver'];

    if (!name?.trim() || !company?.trim()) {
      throw new Error('Specials blacklisted address data must include Name and Company.');
    }
    if (senderOrReceiver !== 'Sender' && senderOrReceiver !== 'Receiver') {
      throw new Error('Sender/Receiver must be either Sender or Receiver.');
    }

    await specialsCriteriaPage.prepareBlacklistedAddress(
      name.trim(),
      company.trim(),
      senderOrReceiver
    );
    messageContext.blacklistedAddress = {
      name: name.trim(),
      company: company.trim(),
      senderOrReceiver,
    };
  }
);

When('I delete the created blacklisted address', async ({ specialsCriteriaPage }) => {
  await specialsCriteriaPage.deleteCreatedBlacklistedAddress();
});
