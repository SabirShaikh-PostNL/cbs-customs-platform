import { Locator, Page, expect } from '@playwright/test';
import { MoasNavigation } from '@/pages/moas-navigation';

const normalizeActionLabel = (label: string) =>
  label.replace(/['"`]/g, '').replace(/\s+/g, ' ').trim().toLowerCase();

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
    const itemIdField = this.page.locator('input[id*="SelectItem"]:visible').first();
    if (!(await itemIdField.isVisible())) {
      await this.navigation.navigateToSubmenu('Functions', 'Data Completion', itemIdField);
    }
    await expect(itemIdField).toBeVisible();
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
    const matchingOptions: { select: Locator; value: string; exact: boolean }[] = [];
    const expectedAction = normalizeActionLabel(action);

    await expect
      .poll(
        async () => {
          matchingOptions.length = 0;
          const selects = await this.page.locator('select:visible:enabled').all();

          for (const select of selects) {
            const options = await select.locator('option:enabled').all();
            for (const option of options) {
              const label =
                (await option.getAttribute('label')) ?? (await option.textContent()) ?? '';
              const normalizedLabel = normalizeActionLabel(label);
              if (normalizedLabel.includes(expectedAction)) {
                const value = await option.getAttribute('value');
                matchingOptions.push({
                  select,
                  value: value ?? label.trim(),
                  exact: normalizedLabel === expectedAction,
                });
              }
            }
          }

          return matchingOptions.length > 0;
        },
        {
          timeout: 15000,
          message: `Action "${action}" should be available in a visible, enabled dropdown`,
        }
      )
      .toBe(true);

    const exactMatches = matchingOptions.filter(option => option.exact);
    const candidates = exactMatches.length > 0 ? exactMatches : matchingOptions;
    if (candidates.length > 1) {
      throw new Error(
        `Action "${action}" matched multiple dropdown options; use a more specific action label.`
      );
    }

    const match = candidates[0];
    await match.select.selectOption({ value: match.value });
    await expect(match.select).toHaveValue(match.value);
  }

  async clickActionButton(buttonName: string) {
    await this.page.getByRole('button', { name: buttonName, exact: true }).click();
  }
}
