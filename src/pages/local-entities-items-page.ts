import { Page, expect } from '@playwright/test';

export class LocalEntitiesItemsPage {
  private searchedItemId?: string;

  constructor(private page: Page) {}

  async navigateToLocalEntitiesItems() {
    await this.page
      .getByRole('menuitem', { name: 'Local entities', exact: true })
      .last()
      .click();
    await this.page
      .getByRole('menuitem', { name: 'Items', exact: true })
      .last()
      .click();
    await expect(this.page.getByRole('heading', { name: 'Item' })).toBeVisible();
  }

  async searchItemsByItemId(itemId: string) {
    const itemIdField = this.page
      .locator('div.mx-grid-search-label')
      .filter({ hasText: 'Item Id' })
      .locator('..')
      .getByRole('textbox');

    await itemIdField.fill(itemId);
    await this.page.getByRole('button', { name: 'Search', exact: true }).click();
    this.searchedItemId = itemId;
  }

  async verifyItemSortingAndDutiable(
    expectedSortingDecision: string,
    expectedDutiable: 'Yes' | 'No'
  ) {
    if (!this.searchedItemId) {
      throw new Error('Search for an item before verifying its details.');
    }

    const itemRow = this.page
      .getByRole('row')
      .filter({ hasText: this.searchedItemId })
      .last();
    const cells = itemRow.getByRole('cell');

    await expect(itemRow).toBeVisible();
    await expect(cells.nth(1)).toContainText(expectedSortingDecision);
    await expect(cells.nth(2)).toHaveText(expectedDutiable);
  }
}