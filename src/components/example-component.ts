/**
 * Example Component: Shipment Card
 * Reusable UI component demonstrating composition pattern.
 * Replace with real components for your application.
 */

import { Locator } from '@playwright/test';

/**
 * ShipmentCard: Encapsulates interactions with a single shipment card in a list.
 * Composed into a page object, not inherited.
 */
export class ShipmentCard {
  constructor(private cardLocator: Locator) {}

  /**
   * Business action: Click to view details.
   */
  async viewDetails(): Promise<void> {
    const viewButton = this.cardLocator.getByRole('button', {
      name: /view|details/i,
    });
    await viewButton.click();
  }

  /**
   * Business action: Get shipment ID from card.
   */
  async getShipmentId(): Promise<string | null> {
    // TODO(APP_SPECIFIC): Replace with real selector
    const idElement = this.cardLocator.getByTestId('shipment-id');
    return idElement.textContent();
  }

  /**
   * Business action: Get displayed status.
   */
  async getStatus(): Promise<string | null> {
    // TODO(APP_SPECIFIC): Replace with real selector
    const statusBadge = this.cardLocator.getByTestId('status-badge');
    return statusBadge.textContent();
  }

  /**
   * Business action: Verify card content matches expected values.
   */
  async verifyContent(expectedId: string, expectedStatus: string): Promise<void> {
    const actualId = await this.getShipmentId();
    const actualStatus = await this.getStatus();

    // Return result; assertions remain in test
    if (actualId !== expectedId || actualStatus !== expectedStatus) {
      throw new Error(
        `Card content mismatch: ` +
          `expected id=${expectedId}, status=${expectedStatus}; ` +
          `got id=${actualId}, status=${actualStatus}`
      );
    }
  }
}
