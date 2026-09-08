import { spawnSync } from 'node:child_process';

export default function globalTeardown() {
  const allure = require.resolve('allure-commandline/bin/allure');
  const result = spawnSync(
    process.execPath,
    [allure, 'generate', 'allure-results', '--clean', '-o', 'allure-report'],
    { stdio: 'inherit' },
  );

  if (result.error) {
    throw result.error;
  }

  if (result.status !== 0) {
    throw new Error(`Allure report generation failed with exit code ${result.status ?? 1}.`);
  }
}
