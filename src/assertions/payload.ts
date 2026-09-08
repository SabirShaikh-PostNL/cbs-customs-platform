/**
 * Focused assertion helpers for domain payloads.
 * Reusable across tests without hiding behavior.
 */

import { Shipment } from '@/models/shipment';

/**
 * Verify shipment payload matches expected created shipment.
 * Used when test creates data via API and needs to verify it was correctly processed.
 */
export function assertShipmentPayloadMatchesCreation(
  createdShipment: Shipment,
  payloadData: Record<string, unknown>
): void {
  const errors: string[] = [];

  // Verify shipment data is present in payload
  if (payloadData.id !== createdShipment.id) {
    errors.push(`ID mismatch: expected ${createdShipment.id}, got ${payloadData.id}`);
  }

  if (payloadData.orderId !== createdShipment.orderId) {
    errors.push(
      `Order ID mismatch: expected ${createdShipment.orderId}, got ${payloadData.orderId}`
    );
  }

  if (payloadData.destination !== createdShipment.destination) {
    errors.push(
      `Destination mismatch: expected ${createdShipment.destination}, got ${payloadData.destination}`
    );
  }

  if (errors.length > 0) {
    throw new Error(`Shipment payload verification failed:\n  ${errors.join('\n  ')}`);
  }
}

/**
 * Verify shipment status in payload matches expected value.
 */
export function assertShipmentStatusInPayload(
  payloadData: Record<string, unknown>,
  expectedStatus: string
): void {
  if (payloadData.status !== expectedStatus) {
    throw new Error(
      `Shipment status mismatch: expected ${expectedStatus}, got ${payloadData.status}`
    );
  }
}
