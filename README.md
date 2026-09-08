# CBS Customs Platform

TypeScript Playwright tests for sending ITMATT and PREDES messages, then verifying that the messages are processed by the MoaS application.

## Nightly GitHub Actions run

The workflow in `.github/workflows/nightly-playwright.yml` runs nightly and can also
be started manually from the GitHub Actions tab. It uploads the Playwright HTML
report, Allure report, screenshots, videos, and traces as a `nightly-test-reports`
artifact, including when tests fail.

Configure these repository secrets before running it:

`ITMATT_URL`, `PREDES_URL`, `API_KEY`, `MOAS_URL`, `MOAS_USER`, and
`MOAS_PASSWORD`.

## Prerequisites

- Node.js 18 or newer
- Access to the target MoaS application and message endpoints
- Valid test credentials and API key

## Setup

Install dependencies:

```bash
npm install
```

Chromium is installed automatically by the `postinstall` script. The `pretest` script checks or installs Chromium before every Playwright run.

Copy `.env.example` to `.env` and fill in environment-specific values:

```env
ITMATT_URL=https://your-itmatt-endpoint
PREDES_URL=https://your-predes-endpoint
API_KEY=replace-with-api-key
MOAS_URL=https://your-moas-host/login.html
MOAS_USER=replace-with-user
MOAS_PASSWORD=replace-with-password
VIDEO_ON_FAILURE=on
```

`.env` and generated BDD tests are ignored by Git. Never commit credentials, API keys,
or environment-specific URLs, and do not expose them in logs, screenshots, traces, or reports.

## Run Tests

Generate native Playwright tests from the Gherkin feature files:

```bash
npm run bddgen
```

Run all Gherkin scenarios:

```bash
npm test
```

Run the feature in headed mode:

```bash
npm run bddgen
npx playwright test --headed
```

Run with the Playwright UI:

```bash
npm run bddgen
npx playwright test --ui
```

Scenarios have stable test-number tags. Run an individual scenario by number:

```powershell
npm run bddgen
npx playwright test --grep "@TC001"
```

```powershell
npm run bddgen
npx playwright test --grep "@TC002"
```

`TC001` is ITMATT and `TC002` is PREDES. Scenario names are shown in the
Playwright report, while tags remain stable if the wording changes.

Run supporting checks:

```bash
npm run test:unit
npm run lint
npm run format:check
```

## Test Coverage

### ITMATT message

`features/message-processing.feature`:

1. Generates a random `UY...ES` S10 item ID.
2. Sends an ITMATT XML message containing item, content, receiver, and sender information.
3. Verifies the API returns HTTP `200`.
4. Logs into the application and searches for the generated item ID.
5. Verifies sorting decision `12` and dutiable status `No`.

### PREDES message

`features/message-processing.feature`:

1. Generates three random `RL...IE` item IDs.
2. Keeps the receptacle prefix `IEDUBANLHAGIAUN` editable in the test.
3. Generates a random 14-digit receptacle suffix.
4. Sends the JSON PREDES receptacle to the `destination=predes` endpoint.
5. Verifies the API returns HTTP `200`.
6. Searches the first item ID in Local entities > Items.
7. Verifies sorting decision `013 - PNP` and dutiable status `No`.
8. Navigates to Testing > Processed requests for automated tests.
9. Opens Search bar and searches the first item ID in Payload.
10. Verifies the matching processed request:

```ts
await processedRequestsPage.verifyProcessedRequest(
  itemId,    // Payload contains this item ID
  'predes',  // Message Name
  'Yes',     // Is processed
  'No',      // Is error
  'No'       // Is failed
);
```

Change the expected values in the scenario when a different result is required.

## Framework Structure

```text
src/
  api/
    itmatt-api.ts             ITMATT API client
    predes-api.ts             PREDES API client
    types.ts                  Shared API types
  config/
    config.ts                 Environment configuration
  fixtures/
    pages.ts                  Shared page-object fixtures
  pages/
    login-page.ts             Login actions
    local-entities-items-page.ts
                              Item search and item assertions
    processed-requests-page.ts
                              Processed-request search and assertions
  parsers/                    XML and JSON parsing helpers
  utils/
    generate-item-id.ts       S10 item and random-number generators

tests/
  steps/
    message-steps.ts          Gherkin step definitions

features/
  message-processing.feature   ITMATT and PREDES scenarios

playwright.config.ts          Playwright projects and reporters
package.json                  Dependencies and npm scripts
tsconfig.json                 TypeScript compiler settings
eslint.config.js              ESLint configuration
```

## Page Object Model

Feature files describe the business flow and expected values. Step definitions orchestrate
the flow, while page objects contain reusable navigation, locator, search, and
table-verification mechanics.

Expected processed-request values stay visible in the PREDES scenario:

```ts
await processedRequestsPage.verifyProcessedRequest(
  itemId,
  'predes',
  'Yes',
  'No',
  'No'
);
```

The page object locates the Payload field through its visible label and matches the returned table row by item ID. It does not rely on absolute XPath or generated Mendix widget IDs.

## Browser and Configuration

The Chromium project in `playwright.config.ts`:

- Starts headed browsers maximized with `--start-maximized`.
- Uses the available browser viewport with `viewport: null`.
- Removes the incompatible device scale factor.
- Records video, screenshots, and traces according to configuration.

`VIDEO_ON_FAILURE=on` retains video for successful and failed runs. The default is `retain-on-failure` when the variable is not set.

## Test Evidence

Playwright records screenshots, videos, and traces according to the configured
failure settings. These artifacts are written under the test result directory and
must not be shared if they contain sensitive application data.

Open the HTML report:

```bash
npx playwright show-report
```

Open a trace:

```bash
npx playwright show-trace test-results/<test-result-directory>/trace.zip
```

Test artifacts are written under `test-results/`; the HTML report is written under `playwright-report/`.
