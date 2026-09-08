/**
 * Fixtures: Page object access.
 * Provides typed page objects to tests.
 * Add each page object fixture here as it's created.
 */

import { TestInfo } from '@playwright/test';
import { test } from 'playwright-bdd';
import { LocalEntitiesItemsPage } from '@/pages/local-entities-items-page';
import { LoginPage } from '@/pages/login-page';
import { ProcessedRequestsPage } from '@/pages/processed-requests-page';
import { SpecialsCriteriaPage } from '@/pages/specials-criteria-page';

interface PageFixtures {
  localEntitiesItemsPage: LocalEntitiesItemsPage;
  loginPage: LoginPage;
  processedRequestsPage: ProcessedRequestsPage;
  specialsCriteriaPage: SpecialsCriteriaPage;
  messageContext: MessageContext;
  bddTestInfo: TestInfo;
}

export interface MessageContext {
  itemId?: string;
  itmattItemId?: string;
  predesItemIds?: string[];
  responseStatus?: number;
  responseBody?: string;
}

export const testWithPages = test.extend<PageFixtures>({
  localEntitiesItemsPage: async ({ page }, use) => {
    await use(new LocalEntitiesItemsPage(page));
  },
  loginPage: async ({ page }, use) => {
    await use(new LoginPage(page));
  },
  processedRequestsPage: async ({ page }, use) => {
    await use(new ProcessedRequestsPage(page));
  },
  specialsCriteriaPage: async ({ page }, use) => {
    await use(new SpecialsCriteriaPage(page));
  },
  messageContext: async ({ page }, use) => {
    void page;
    await use({});
  },
  bddTestInfo: async ({}, use, testInfo) => {
    await use(testInfo);
  },
});

export { testWithPages as test };
