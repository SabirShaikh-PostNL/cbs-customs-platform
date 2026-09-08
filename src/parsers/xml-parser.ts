/**
 * XML parsing with focused, predictable API.
 * Uses fast-xml-parser for performance and reliability.
 */

import { XMLParser } from 'fast-xml-parser';

/**
 * Parse XML string into a predictable object structure.
 * Preserves all values as-is without silent conversion.
 */
export async function parseXml(xmlString: string): Promise<Record<string, unknown>> {
  try {
    const parser = new XMLParser({
      // Parser options: predictable behavior, minimal surprises
      parseTagValue: false, // Don't auto-parse values as numbers/booleans
      parseAttributeValue: false, // Keep attribute values as strings
      attributeNamePrefix: '@_', // Distinguish attributes from elements
      textNodeName: '#text',
      ignoreAttributes: false,
    });

    const result = parser.parse(xmlString) as Record<string, unknown>;
    return result;
  } catch (error) {
    throw new Error(
      `Failed to parse XML: ${error instanceof Error ? error.message : String(error)}`
    );
  }
}

/**
 * Read a nested value from parsed XML by dot-notation path.
 * Example: readXmlValue(parsed, 'root.shipment.id')
 */
export function readXmlValue(
  data: Record<string, unknown>,
  path: string
): unknown {
  const parts = path.split('.');
  let current: unknown = data;

  for (const part of parts) {
    if (current === null || current === undefined) {
      return undefined;
    }

    if (typeof current === 'object') {
      current = (current as Record<string, unknown>)[part];
    } else {
      return undefined;
    }
  }

  return current;
}

/**
 * Verify that a required XML field exists and matches an expected value.
 */
export function assertXmlField(
  data: Record<string, unknown>,
  path: string,
  expectedValue: string | number,
  message?: string
): void {
  const actual = readXmlValue(data, path);

  if (actual !== expectedValue) {
    throw new Error(
      message ??
        `XML field mismatch at '${path}': ` +
          `expected ${JSON.stringify(expectedValue)}, ` +
          `got ${JSON.stringify(actual)}`
    );
  }
}

/**
 * Verify that a required XML field exists.
 */
export function assertXmlFieldExists(
  data: Record<string, unknown>,
  path: string,
  message?: string
): void {
  const value = readXmlValue(data, path);

  if (value === undefined || value === null) {
    throw new Error(
      message ?? `Required XML field '${path}' not found`
    );
  }
}
