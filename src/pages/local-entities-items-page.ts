import { Page, expect } from '@playwright/test';
import { MoasNavigation } from '@/pages/moas-navigation';

export class LocalEntitiesItemsPage {
  private searchedItemId?: string;
  private navigation: MoasNavigation;

  constructor(private page: Page) {
    this.navigation = new MoasNavigation(page);
  }

  async navigateToLocalEntitiesItems() {
    await this.navigation.navigateToSubmenu('Local entities', 'Items', this.getItemIdSearchField());
    await expect(
      this.getItemIdSearchField(),
      'The Items page search field should be visible after navigation'
    ).toBeVisible();
  }

  async searchItemsByItemId(itemId: string) {
    const itemIdField = this.getItemIdSearchField();
    await itemIdField.fill(itemId);
    await this.page.getByRole('button', { name: 'Search', exact: true }).click();
    this.searchedItemId = itemId;
  }

  private getItemIdSearchField() {
    return this.page.getByRole('textbox', { name: /^Item id$/i });
  }

  async verifyItemSortingAndDutiable(
    expectedSortingDecision: string,
    expectedDutiable: 'Yes' | 'No'
  ) {
    if (!this.searchedItemId) {
      throw new Error('Search for an item before verifying its details.');
    }

    const itemRow = this.page.getByRole('row').filter({ hasText: this.searchedItemId }).last();
    const cells = itemRow.getByRole('cell');

    await expect(itemRow).toBeVisible();
    await expect(cells.nth(1)).toContainText(expectedSortingDecision);
    await expect(cells.nth(2)).toHaveText(expectedDutiable);
  }

  async verifyItemSorting(expectedSortingDecision: string) {
    if (!this.searchedItemId) {
      throw new Error('Search for an item before verifying its details.');
    }

    const itemRow = this.page.getByRole('row').filter({ hasText: this.searchedItemId }).last();

    await expect(itemRow).toBeVisible();
    await expect(itemRow.getByRole('cell').nth(1)).toContainText(expectedSortingDecision);
  }
}
