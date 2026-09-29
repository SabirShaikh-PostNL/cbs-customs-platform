import { Page, expect } from '@playwright/test';
import { MoasNavigation } from '@/pages/moas-navigation';
import { getJsonPathValue } from '@/utils/json-path';

export class MessagesSentToEmagizPage {
  private navigation: MoasNavigation;

  constructor(private page: Page) {
    this.navigation = new MoasNavigation(page);
  }

  async navigateToMessagesSentToEmagiz() {
    await this.navigation.navigateToSubmenu('Testing', 'Messages sent to eMagiz');
    await expect(
      this.page.getByRole('heading', { name: 'Messages sent to eMagiz', exact: true })
    ).toBeVisible();
  }

  async searchByItemId(itemId: string) {
    await this.page.getByRole('button', { name: 'Search bar', exact: true }).click();

    const payloadField = this.page
      .locator('div.mx-grid-search-item')
      .filter({ hasText: /^Payload$/ })
      .getByRole('textbox');

    await payloadField.fill(itemId);
    await this.page.getByRole('button', { name: 'Search', exact: true }).click();
  }

  async verifyMessages(itemId: string, expectedMessages: Array<Record<string, string>>) {
    const expectedColumns = Object.keys(expectedMessages[0] ?? {});
    if (expectedColumns.length === 0) {
      throw new Error('Expected message table must include at least one column.');
    }

    const headers = (await this.page.getByRole('columnheader').allTextContents()).map(header =>
      header.trim().toLowerCase()
    );
    const columnIndexes = expectedColumns.map(column => {
      const index = headers.indexOf(column.trim().toLowerCase());
      if (index < 0) {
        throw new Error(`Column not found in Messages sent to eMagiz: ${column}`);
      }
      return index;
    });

    const rows = this.page.getByRole('row').filter({ hasText: itemId });
    await expect(rows).toHaveCount(expectedMessages.length, { timeout: 30000 });

    const actualRows = await Promise.all(
      (await rows.all()).map(async row => {
        const cells = (await row.getByRole('cell').allTextContents()).map(cell => cell.trim());
        return columnIndexes.map(index => cells[index] ?? '');
      })
    );
    const expectedRows = expectedMessages.map(message =>
      expectedColumns.map(column => message[column]?.trim() ?? '')
    );
    const normalize = (values: string[][]) => values.map(row => JSON.stringify(row)).sort();

    expect(normalize(actualRows)).toEqual(normalize(expectedRows));
  }

  async verifyPayload(
    target: string,
    itemId: string,
    assertions: Array<{ jsonPath: string; expectedValue: string }>
  ) {
    const headers = (await this.page.getByRole('columnheader').allTextContents()).map(header =>
      header.trim().toLowerCase()
    );
    const targetIndex = headers.indexOf('target');
    const payloadIndex = headers.indexOf('payload');
    if (targetIndex < 0 || payloadIndex < 0) {
      throw new Error('Target and Payload columns are required to verify eMagiz messages.');
    }

    const rows = await this.page.getByRole('row').filter({ hasText: itemId }).all();
    const payloads: unknown[] = [];
    for (const row of rows) {
      const cells = row.getByRole('cell');
      if ((await cells.nth(targetIndex).innerText()).trim() !== target) {
        continue;
      }

      const payloadText = await cells.nth(payloadIndex).textContent();
      if (!payloadText) {
        continue;
      }
      payloads.push(JSON.parse(payloadText));
    }

    const expectedValue = (value: string) => {
      const resolvedValue = value === 'Generated ItemId' ? itemId : value;
      try {
        return JSON.parse(resolvedValue) as unknown;
      } catch {
        return resolvedValue;
      }
    };

    const matchingPayload = payloads.find(payload =>
      assertions.every(
        assertion =>
          JSON.stringify(getJsonPathValue(payload, assertion.jsonPath)) ===
          JSON.stringify(expectedValue(assertion.expectedValue))
      )
    );

    expect(
      matchingPayload,
      `No payload for target ${target} matched the expected JSON paths and values.`
    ).toBeDefined();
  }
}