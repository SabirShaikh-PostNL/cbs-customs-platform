import { expect, Page } from '@playwright/test';

export class SpecialsCriteriaPage {
  private createdCriterion?: string;
  private createdKeyword?: string;
  private createdAddress?: {
    name: string;
    company: string;
    senderOrReceiver: 'Sender' | 'Receiver';
  };

  constructor(private page: Page) {}

  async navigateToSpecialsCriteria() {
    await this.page.getByRole('menuitem', { name: 'Settings', exact: true }).last().click();

    await this.page
      .getByRole('menuitem', { name: 'Specials Criteria', exact: true })
      .last()
      .click();

    await expect(this.page.getByText("Criteria for 'Special goods'")).toBeVisible();
  }

  async addHsCodeCriterion(criterion: string, description: string) {
    await this.page.getByRole('button', { name: 'New' }).click();

    const modal = this.page
      .locator('.mx-window:visible')
      .filter({ hasText: 'Edit Specials Criterion' })
      .last();

    await expect(modal).toBeVisible();
    await modal.getByLabel('Criterion', { exact: true }).fill(criterion);
    await modal.getByLabel('Description', { exact: true }).fill(description);

    await modal.getByRole('button', { name: 'Save', exact: true }).click();
    this.createdCriterion = criterion;
  }

  async verifyCriterionExists(criterion: string, description: string) {
    const row = this.page.getByRole('row').filter({ hasText: criterion });

    await expect(row).toBeVisible();

    await expect(row).toContainText(description);
  }

  async deleteCriterion(criterion: string) {
    const hsCodesTab = this.page.getByRole('tabpanel', { name: 'HS Codes' }).first();
    await hsCodesTab.getByRole('button', { name: 'Search bar', exact: true }).first().click();

    const criterionSearch = hsCodesTab.getByLabel('Criterion', { exact: true }).first();

    await criterionSearch.fill(criterion);
    await hsCodesTab.getByRole('button', { name: 'Search', exact: true }).first().click();

    const firstRow = hsCodesTab.locator('tr.mx-name-index-0').first();
    await expect(firstRow).toContainText(criterion);
    await firstRow.click();
    await hsCodesTab.getByRole('button', { name: 'Delete', exact: true }).first().click();
    await this.page.getByRole('button', { name: 'OK' }).first().click();
  }

  async deleteCreatedCriterion() {
    if (!this.createdCriterion) {
      throw new Error('No Specials criterion was created in this scenario.');
    }

    await this.deleteCriterion(this.createdCriterion);
  }

  async addKeyword(keyword: string) {
    await this.page.getByRole('tab', { name: 'Keywords', exact: true }).click();
    const keywordsTab = this.page.getByRole('tabpanel', { name: 'Keywords' }).first();

    await keywordsTab.getByRole('button', { name: 'New', exact: true }).click();

    const modal = this.page
      .locator('.mx-window:visible')
      .filter({ hasText: 'Edit Specials Criterion' })
      .last();

    await expect(modal).toBeVisible();
    await modal.getByLabel('Key word', { exact: true }).fill(keyword);
    await modal.getByRole('button', { name: 'Save', exact: true }).click();
    this.createdKeyword = keyword;
  }

  async deleteKeyword(keyword: string) {
    await this.page.getByRole('tab', { name: 'Keywords', exact: true }).click();
    const keywordsTab = this.page.getByRole('tabpanel', { name: 'Keywords' }).first();

    await keywordsTab.getByRole('button', { name: 'Search', exact: true }).first().click();
    const keywordSearch = keywordsTab.getByLabel('Criterion', { exact: true }).first();
    await keywordSearch.fill(keyword.toLowerCase());
    await keywordsTab
      .locator('.mx-grid-search-controls')
      .getByRole('button', { name: 'Search', exact: true })
      .click();

    const firstResultRow = keywordsTab
      .locator('table[dojoattachpoint="gridTable"] tbody tr:visible')
      .first();
    await expect(firstResultRow).toBeVisible();
    await firstResultRow.click({ force: true });
    await keywordsTab.getByRole('button', { name: 'Delete', exact: true }).first().click();
    await this.page.getByRole('button', { name: 'OK' }).first().click();
  }

  async deleteCreatedKeyword() {
    if (!this.createdKeyword) {
      throw new Error('No Specials keyword was created in this scenario.');
    }

    await this.deleteKeyword(this.createdKeyword);
  }

  async prepareBlacklistedAddress(
    name: string,
    company: string,
    senderOrReceiver: 'Sender' | 'Receiver'
  ) {
    await this.page.getByRole('tab', { name: 'Blacklisted addresses', exact: true }).click();
    const keywordsTab = this.page.getByRole('tabpanel', { name: 'Blacklisted addresses' }).first();

    await keywordsTab.getByRole('button', { name: 'New', exact: true }).click();

    const modal = this.page
      .locator('.mx-window:visible')
      .filter({ hasText: 'Edit Address' })
      .last();

    await expect(modal).toBeVisible();
    await modal.getByLabel('Name', { exact: true }).fill(name);
    await modal.getByLabel('Company name', { exact: true }).fill(company);

    const radioGroup = modal.locator(
      senderOrReceiver === 'Sender' ? '.mx-name-radioButtons1' : '.mx-name-radioButtons2'
    );
    await radioGroup.getByRole('radio', { name: 'Yes' }).check();

    this.createdAddress = { name, company, senderOrReceiver };
  }

  async completeBlacklistedAddress(
    houseNumber: string,
    houseNumberAddition: string,
    postalCode: string,
    country: string
  ) {
    if (!this.createdAddress) {
      throw new Error('Prepare the blacklisted address before completing it.');
    }

    const modal = this.page
      .locator('.mx-window:visible')
      .filter({ hasText: 'Edit Address' })
      .last();

    await modal.getByLabel('House number', { exact: true }).fill(houseNumber);
    await modal.getByLabel('House number addition', { exact: true }).fill(houseNumberAddition);
    await modal.getByLabel('Postal code', { exact: true }).fill(postalCode);
    await modal.getByLabel('Country', { exact: true }).fill(country);
    await modal.getByLabel('Blacklist reason', { exact: true }).fill('Blacklisted for testing');
    await modal.getByRole('button', { name: 'Save', exact: true }).click();
  }

  async deleteCreatedBlacklistedAddress() {
    if (!this.createdAddress) {
      throw new Error('No blacklisted address was created in this scenario.');
    }

    await this.page.getByRole('tab', { name: 'Blacklisted addresses', exact: true }).click();
    const addressesTab = this.page.getByRole('tabpanel', { name: 'Blacklisted addresses' }).first();
    await addressesTab.getByRole('button', { name: 'Search', exact: true }).first().click();
    await addressesTab.getByLabel('Name', { exact: true }).fill(this.createdAddress.name);
    await addressesTab
      .getByLabel('Company name', { exact: true })
      .fill(this.createdAddress.company);
    await addressesTab
      .locator('.mx-grid-search-controls')
      .getByRole('button', { name: 'Search', exact: true })
      .click();

    const row = addressesTab
      .locator('table[dojoattachpoint="gridTable"] tbody tr:visible')
      .filter({ hasText: this.createdAddress.company })
      .filter({ hasText: this.createdAddress.name })
      .first();
    await expect(row).toBeVisible();
    await row.click({ force: true });
    await addressesTab.getByRole('button', { name: 'Delete', exact: true }).first().click();
    await this.page.getByRole('button', { name: 'OK' }).first().click();
  }
}
