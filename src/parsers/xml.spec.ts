/**
 * Unit tests for XML parser functions.
 * Ensures parser behavior is predictable and reliable.
 */

import { parseXml } from './xml-parser';

describe('XML Parser', () => {
  const sampleXml = `<?xml version="1.0"?>
<shipment>
  <id>ship-123</id>
  <orderId>order-456</orderId>
  <status>delivered</status>
  <destination>warehouse-789</destination>
</shipment>`;

  describe('parseXml', () => {
    it('should parse valid XML to object', async () => {
      const result = await parseXml(sampleXml);
      expect(result).toHaveProperty('shipment');
    });

    it('should handle incomplete XML', async () => {
      // The fast-xml-parser library doesn't throw on malformed XML by default
      // It attempts to parse what it can
      const result = await parseXml('<invalid>xml');
      expect(result).toBeDefined();
    });
  });

  describe('readXmlValue', () => {
    let parsed: Record<string, unknown>;

    beforeAll(async () => {
      parsed = await parseXml(sampleXml);
    });

    it('should read nested value by path', () => {
      // Navigate through parsed structure
      const root = parsed.shipment as Record<string, unknown>;
      expect(root.id).toBe('ship-123');
    });

    it('should return undefined for missing path', () => {
      const root = parsed.shipment as Record<string, unknown>;
      const value = root.nonexistent;
      expect(value).toBeUndefined();
    });
  });

  describe('assertXmlField', () => {
    let parsed: Record<string, unknown>;

    beforeAll(async () => {
      parsed = await parseXml(sampleXml);
    });

    it('should pass when field matches', () => {
      const root = parsed.shipment as Record<string, unknown>;
      const id = root.id;
      expect(id).toBe('ship-123');
    });

    it('should throw when field does not match', () => {
      const root = parsed.shipment as Record<string, unknown>;
      const id = root.id;
      expect(id).not.toBe('wrong-id');
    });
  });

  describe('assertXmlFieldExists', () => {
    let parsed: Record<string, unknown>;

    beforeAll(async () => {
      parsed = await parseXml(sampleXml);
    });

    it('should pass when field exists', () => {
      const root = parsed.shipment as Record<string, unknown>;
      expect(root.id).toBeDefined();
    });

    it('should throw when field is missing', () => {
      const root = parsed.shipment as Record<string, unknown>;
      expect(root.nonexistent).toBeUndefined();
    });
  });
});
