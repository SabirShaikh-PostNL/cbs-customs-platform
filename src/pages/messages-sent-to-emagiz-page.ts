import { Page, expect } from '@playwright/test';
import { MoasNavigation } from '@/pages/moas-navigation';
import { getJsonPathValue } from '@/utils/json-path';

function normalizeScalar(value: unknown): unknown {
  if (typeof value !== 'string') {
    return value;
  }

  const trimmed = value.trim();
  if (trimmed === '') {
    return '';
  }
  if (trimmed === 'true') {
    return true;
  }
  if (trimmed === 'false') {
    return false;
  }
  if (/^-?\d+(\.\d+)?$/.test(trimmed)) {
    return Number(trimmed);
  }
  return trimmed;
}

function getXmlValue(xmlText: string, xmlPath: string): unknown {
  const normalizedPath = xmlPath.trim();
  const segments = normalizedPath.replace(/^\/+/, '').split('/').filter(Boolean);
  if (segments.length === 0) {
    return undefined;
  }

  let currentText = xmlText;
  for (const segment of segments) {
    const match = new RegExp(`<${segment}>([\\s\\S]*?)<\\/${segment}>`, 'i').exec(currentText);
    if (!match) {
      const fallback = new RegExp(`<${segment}>([\\s\\S]*?)<\\/${segment}>`, 'i').exec(xmlText);
      if (!fallback) {
        return undefined;
      }
      currentText = fallback[1];
      continue;
    }
    currentText = match[1];
  }

  return normalizeScalar(currentText.trim());
}

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
    assertions: Array<{ path: string; expectedValue: string }>
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
      payloads.push(payloadText);
    }

    const expectedValue = (value: string) => {
      const resolvedValue = value === 'Generated ItemId' ? itemId : value;
      try {
        return JSON.parse(resolvedValue) as unknown;
      } catch {
        return resolvedValue;
      }
    };

    const parsePayload = (payload: unknown): unknown => {
      if (typeof payload !== 'string') {
        return payload;
      }
      const trimmed = payload.trim();
      if (trimmed.startsWith('<')) {
        return payload;
      }
      try {
        return JSON.parse(trimmed) as unknown;
      } catch {
        return payload;
      }
    };

    const getValueForAssertion = (payload: unknown, assertion: { path: string }) => {
      const parsedPayload = parsePayload(payload);
      if (typeof parsedPayload === 'string' && parsedPayload.trim().startsWith('<')) {
        return getXmlValue(parsedPayload, assertion.path);
      }
      return getJsonPathValue(parsedPayload, assertion.path);
    };

    const matchingPayload = payloads.find(payload =>
      assertions.every(
        assertion =>
          JSON.stringify(getValueForAssertion(payload, assertion)) ===
          JSON.stringify(expectedValue(assertion.expectedValue))
      )
    );

    expect(
      matchingPayload,
      `No payload for target ${target} matched the expected paths and values.`
    ).toBeDefined();
  }
}