/**
 * JSON parsing and validation helpers.
 * Provides typed access and assertions without schema library overhead.
 */

/**
 * Safely parse JSON string with clear error reporting.
 */
export function parseJson<T>(jsonString: string): T {
  try {
    return JSON.parse(jsonString) as T;
  } catch (error) {
    throw new Error(
      `Failed to parse JSON: ${error instanceof Error ? error.message : String(error)}`
    );
  }
}

/**
 * Read a nested value from an object by dot-notation path.
 * Example: readJsonValue(data, 'shipment.status')
 */
export function readJsonValue(
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
 * Verify that a required JSON field exists and matches an expected value.
 */
export function assertJsonField(
  data: Record<string, unknown>,
  path: string,
  expectedValue: unknown,
  message?: string
): void {
  const actual = readJsonValue(data, path);

  if (actual !== expectedValue) {
    throw new Error(
      message ??
        `JSON field mismatch at '${path}': ` +
          `expected ${JSON.stringify(expectedValue)}, ` +
          `got ${JSON.stringify(actual)}`
    );
  }
}

/**
 * Verify that a required JSON field exists.
 */
export function assertJsonFieldExists(
  data: Record<string, unknown>,
  path: string,
  message?: string
): void {
  const value = readJsonValue(data, path);

  if (value === undefined || value === null) {
    throw new Error(
      message ?? `Required JSON field '${path}' not found`
    );
  }
}

/**
 * Format JSON for readable error output (truncated if very large).
 */
export function formatJsonForDiagnostics(data: unknown, maxLength = 500): string {
  const formatted = JSON.stringify(data, null, 2);
  if (formatted.length > maxLength) {
    return formatted.substring(0, maxLength) + '\n... (truncated)';
  }
  return formatted;
}
