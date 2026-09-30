import { Page, expect } from '@playwright/test';
import { MoasNavigation } from '@/pages/moas-navigation';

export class DataCompletionPage {
  private readonly addressFieldNames = [
    'Country',
    'State or province',
    'Postal code',
    'House number',
    'House number addition',
    'Street',
    'City',
  ] as const;
  private navigation: MoasNavigation;

  constructor(private page: Page) {
    this.navigation = new MoasNavigation(page);
  }

  async navigateToDataCompletion() {
    await this.navigation.navigateToSubmenu('Functions', 'Data Completion');
    await expect(this.page.getByRole('heading', { name: 'Data completion', exact: true })).toBeVisible();
  }

  async searchByItemId(itemId: string) {
    const itemIdField = this.page.locator('input[id*="SelectItem"]').first();
    await itemIdField.fill(itemId);
    await this.page.getByRole('button', { name: 'Enter', exact: true }).click();
  }

  async fillAddressDetails(address: Record<string, string>) {
    const receiverAddress = this.page.getByRole('region', { name: 'Receiver address' });

    for (const fieldName of this.addressFieldNames) {
      const value = address[fieldName];
      if (value !== undefined && value.trim() !== '') {
        const field = receiverAddress.getByLabel(fieldName, { exact: true });
        await field.fill(value.trim());

        if (fieldName === 'House number') {
          await field.press('Tab');
        }
      }
    }
  }

  async verifyReceiverCity(expectedCity: string) {
    const receiverAddress = this.page.getByRole('region', { name: 'Receiver address' });
    await expect(receiverAddress.getByLabel('City', { exact: true })).toHaveValue(expectedCity);
  }

  async changeReceiverCountry(country: string) {
    const receiverAddress = this.page.getByRole('region', { name: 'Receiver address' });
    await receiverAddress.getByLabel('Country', { exact: true }).fill(country);
  }

  async fillBvaReason(reason: string) {
    await this.page.getByLabel('BVA reason', { exact: true }).fill(reason);
  }

  async selectItemAction(action: string) {
    const actionSelect = this.page
      .locator('select')
      .filter({ has: this.page.locator('option', { hasText: action }) })
      .first();

    await expect(actionSelect).toBeVisible({ timeout: 15000 });
    await actionSelect.selectOption({ label: action });
    await expect(actionSelect).toHaveValue(/.+/);
  }

  async clickActionButton(buttonName: string) {
    await this.page.getByRole('button', { name: buttonName, exact: true }).click();
  }
}