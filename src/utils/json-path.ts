export function getJsonPathValue(value: unknown, jsonPath: string): unknown {
  if (!jsonPath.startsWith('$')) {
    throw new Error(`JSON path must start with $: ${jsonPath}`);
  }

  const path = jsonPath.slice(1);
  const tokenPattern = /(?:\.([A-Za-z_$][\w$]*)|\[(\d+)\]|\[['"]((?:\\.|[^'"\\])+)['"]\])/g;
  const segments: Array<string | number> = [];
  let position = 0;

  while (position < path.length) {
    tokenPattern.lastIndex = position;
    const match = tokenPattern.exec(path);
    if (!match) {
      throw new Error(`Unsupported JSON path expression: ${jsonPath}`);
    }

    const index = match[2];
    const quotedProperty = match[3];
    segments.push(match[1] ?? (index === undefined ? quotedProperty : Number(index)));
    position = tokenPattern.lastIndex;
  }

  return segments.reduce<unknown>((current, segment) => {
    if (typeof segment === 'number') {
      return Array.isArray(current) ? current[segment] : undefined;
    }
    if (current === null || typeof current !== 'object') {
      return undefined;
    }
    return (current as Record<string, unknown>)[segment];
  }, value);
}