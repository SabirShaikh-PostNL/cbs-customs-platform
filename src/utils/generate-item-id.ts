export function generateS10Barcode(
  serviceIndicator = 'RR',
  countryCode = 'ES'
): string {

  const serial = Math.floor(Math.random() * 100000000)
    .toString()
    .padStart(8, '0');

  const checkDigit = calculateS10CheckDigit(serial);

  return `${serviceIndicator}${serial}${checkDigit}${countryCode}`;
}

export function generateRandomNumber(length: number): string {
  return Array.from({ length }, () => Math.floor(Math.random() * 10)).join('');
}

function calculateS10CheckDigit(serial: string): number {
  const weights = [8, 6, 4, 2, 3, 5, 9, 7];

  const sum = serial
    .split('')
    .reduce((acc, digit, idx) =>
      acc + Number(digit) * weights[idx], 0);

  const remainder = sum % 11;

  const checkDigit = 11 - remainder;

  if (checkDigit === 10) return 0;
  if (checkDigit === 11) return 5;

  return checkDigit;
}