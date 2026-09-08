import 'dotenv/config';

type VideoMode = 'on' | 'off' | 'retain-on-failure';

function required(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

export function getConfig() {
  return {
    itmattUrl: required('ITMATT_URL'),
    predesUrl: required('PREDES_URL'),
    apiKey: required('API_KEY'),

    moasUrl: required('MOAS_URL'),
    moasUser: required('MOAS_USER'),
    moasPassword: required('MOAS_PASSWORD'),
    traceOnFailure: true,
    screenshotOnFailure: true,
    videoOnFailure: (process.env.VIDEO_ON_FAILURE ?? 'retain-on-failure') as VideoMode,
  };
}
