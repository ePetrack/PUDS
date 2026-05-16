export const UTILITIES = ['electric', 'gas', 'water'] as const;
export const UNITS = ['kWh', 'm3', 'therm', 'gal', 'L'] as const;

export type Utility = (typeof UTILITIES)[number];
export type Unit = (typeof UNITS)[number];

export function isUtility(x: unknown): x is Utility {
  return typeof x === 'string' && (UTILITIES as readonly string[]).includes(x);
}

export function isUnit(x: unknown): x is Unit {
  return typeof x === 'string' && (UNITS as readonly string[]).includes(x);
}
