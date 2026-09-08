import { Locator, Page, expect } from '@playwright/test';

export class ProcessedRequestsPage {
  constructor(private page: Page) {}

  async navigateToProcessedRequests() {
    await this.page
      .getByRole('menuitem', { name: 'Testing', exact: true })
      .last()
      .click();
    await this.page
      .getByRole('menuitem', { name: 'Processed requests for automated tests', exact: true })
      .click();
    await expect(
      this.page.getByRole('heading', { name: 'Processed Request' })
    ).toBeVisible();
  }

  async searchByPayload(itemId: string) {
    await this.page.getByRole('button', { name: 'Search bar', exact: true }).click();

    const payloadField = this.page
      .locator('div.mx-grid-search-item')
      .filter({ hasText: /^Payload$/ })
      .getByRole('textbox');

    await payloadField.fill(itemId);
    await this.page.getByRole('button', { name: 'Search', exact: true }).click();
  }

  async verifyProcessedRequest(
    itemId: string,
    expectedMessageName: string,
    expectedIsProcessed: 'Yes' | 'No',
    expectedIsError: 'Yes' | 'No',
    expectedIsFailed: 'Yes' | 'No'
  ) {
    const row = this.page
      .getByRole('row')
      .filter({ hasText: itemId })
      .last();
    await expect(row).toBeVisible({ timeout: 30000 });

    await expect(await this.cellForColumn(row, 'Payload')).toContainText(itemId);
    await expect(await this.cellForColumn(row, 'Message name')).toHaveText(expectedMessageName);
    await expect(await this.cellForColumn(row, 'Is processed')).toHaveText(expectedIsProcessed);
    await expect(await this.cellForColumn(row, 'Is error')).toHaveText(expectedIsError);
    await expect(await this.cellForColumn(row, 'Is failed')).toHaveText(expectedIsFailed);
  }

  private async cellForColumn(row: Locator, columnName: string) {
    const headers = await this.page
      .getByRole('columnheader')
      .allTextContents();
    const columnIndex = headers.findIndex((header) =>
      header.trim().toLowerCase() === columnName.toLowerCase()
    );

    if (columnIndex < 0) {
      throw new Error(`Column not found: ${columnName}`);
    }

    return row.getByRole('cell').nth(columnIndex);
  }
}