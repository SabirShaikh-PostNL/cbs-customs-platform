import { expect, Page } from '@playwright/test';
import { MoasNavigation } from '@/pages/moas-navigation';

export class KFycoHandlingPage {
  private navigation: MoasNavigation;

  private readonly actionButtonIds: Record<string, string> = {
    'K-FYCO OK': 'actionButton3',
    'New K-FYCO': 'actionButton4',
  };

  constructor(private page: Page) {
    this.navigation = new MoasNavigation(page);
  }

  private getActionButton(action: string) {
    const buttonId = this.actionButtonIds[action];
    if (!buttonId) {
      throw new Error(`Unsupported K-FYCO action: "${action}".`);
    }

    return this.page.locator(`button[data-button-id="p.MoaS_Item.Item_K_FYCO.${buttonId}"]`);
  }

  private getAvailableActionButtons() {
    return this.getActionButton('K-FYCO OK').or(this.getActionButton('New K-FYCO'));
  }

  async searchByItemId(itemId: string, pageName: string) {
    const itemIdField = this.page.locator('input[id*="SelectItem"]:visible').first();
    await this.navigation.navigateToSubmenu('Functions', pageName, itemIdField);
    await expect(itemIdField).toBeVisible();
    await itemIdField.fill(itemId);
    await this.page.getByRole('button', { name: 'Enter', exact: true }).click();
    await expect(
      this.getAvailableActionButtons(),
      'A K-FYCO action should be available after searching for the item'
    ).toBeVisible();
  }

  async markItemAs(action: string) {
    const actionButton = this.getActionButton(action);
    await expect(actionButton, `Action "${action}" should be available`).toBeVisible();
    await expect(actionButton).toBeEnabled();
    await actionButton.scrollIntoViewIfNeeded();
    await actionButton.click();
    await this.page.getByRole('button', { name: 'Save data', exact: true }).click();

    const confirmationDialog = this.page.getByRole('dialog').last();
    await expect(
      confirmationDialog,
      'The K-FYCO confirmation should appear after saving'
    ).toBeVisible();
    await confirmationDialog.getByRole('button', { name: 'OK', exact: true }).click();
    await expect(confirmationDialog).toBeHidden();
  }
}
