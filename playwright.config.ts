import { defineConfig, devices } from '@playwright/test';
import { defineBddConfig } from 'playwright-bdd';
import { getConfig } from './src/config/config';

const config = getConfig();
const isHeaded = process.argv.includes('--headed');
const testDir = defineBddConfig({
  features: 'features/**/*.feature',
  steps: ['tests/steps/**/*.ts', 'src/fixtures/pages.ts'],
  outputDir: '.features-gen',
});

export default defineConfig({
  testDir,
  testMatch: '**/*.spec.js',
  timeout: 30000, // Per test timeout
  expect: {
    timeout: 5000, // Per assertion timeout
  },
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 1 : 0, // Retry in CI only
  workers: process.env.CI ? 1 : undefined, // Single worker in CI for debugging
  globalSetup: './allure.global-setup.ts',
  globalTeardown: './allure.global-teardown.ts',
  reporter: [
    ['list'],
    ['json', { outputFile: 'test-results/results.json' }],
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
    ['allure-playwright', { outputFolder: 'allure-results' }],
  ],
  use: {
    trace: config.traceOnFailure ? 'on' : 'off',
    screenshot: config.screenshotOnFailure ? 'on' : 'off',
    video: config.videoOnFailure,
    launchOptions: {
      slowMo: 100, // Reduced from 1000 for faster test runs
    },
  },
  projects: [
    {
      name: 'chromium',
      use: {
        ...devices['Desktop Chrome'],
        viewport: isHeaded ? null : { width: 1280, height: 720 },
        ...(isHeaded
          ? {
              deviceScaleFactor: undefined,
              launchOptions: { args: ['--start-maximized'] },
            }
          : {}),
      },
    },
  ],
});
