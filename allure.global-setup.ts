import fs from 'node:fs';

export default function globalSetup() {
  fs.rmSync('allure-results', { recursive: true, force: true });
}
