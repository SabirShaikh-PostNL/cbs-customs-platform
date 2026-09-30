import { expect, Page } from '@playwright/test';
import { MoasNavigation } from '@/pages/moas-navigation';

export class SpecialsHandlingPage {
  private navigation: MoasNavigation;

  constructor(private page: Page) {
    this.navigation = new MoasNavigation(page);
  }

  async searchByItemId(itemId: string) {
    const itemIdField = this.page.locator('input[id*="SelectItem"]:visible').first();
    await this.navigation.navigateToSubmenu('Functions', 'Specials handling', itemIdField);
    await expect(itemIdField).toBeVisible();
    await itemIdField.fill(itemId);
    await itemIdField.press('Enter');
    await expect(
      this.page.getByRole('button', { name: 'Mark as "no special"via DC', exact: true })
    ).toBeVisible();
  }

  async markItemAsNoLongerSpecial() {
    await this.page
      .getByRole('button', { name: 'Mark as "no special"via DC', exact: true })
      .click();
  }

  async verifyNoLongerSpecialConfirmation(itemId: string, sortingDecision: string) {
    const informationDialog = this.page
      .getByRole('dialog')
      .filter({ hasText: 'Information' })
      .last();

    await expect(informationDialog).toBeVisible();
    await expect(informationDialog).toContainText(
      `Item ${itemId} is now no longer special and now has sortingdecision ${sortingDecision}.`
    );
  }

  async acceptInformationDialog() {
    const informationDialog = this.page
      .getByRole('dialog')
      .filter({ hasText: 'Information' })
      .last();

    await informationDialog.getByRole('button', { name: 'OK', exact: true }).click();
    await expect(informationDialog).toBeHidden();
  }
}
