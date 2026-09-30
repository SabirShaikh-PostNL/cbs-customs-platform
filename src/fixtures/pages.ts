/**
 * Fixtures: Page object access.
 * Provides typed page objects to tests.
 * Add each page object fixture here as it's created.
 */

import { TestInfo } from '@playwright/test';
import { test } from 'playwright-bdd';
import { DataCompletionPage } from '@/pages/data-completion-page';
import { LocalEntitiesItemsPage } from '@/pages/local-entities-items-page';
import { LoginPage } from '@/pages/login-page';
import { MessagesSentToEmagizPage } from '@/pages/messages-sent-to-emagiz-page';
import { ProcessedRequestsPage } from '@/pages/processed-requests-page';
import { SpecialsCriteriaPage } from '@/pages/specials-criteria-page';
import { SpecialsHandlingPage } from '@/pages/specials-handling-page';

interface PageFixtures {
  dataCompletionPage: DataCompletionPage;
  localEntitiesItemsPage: LocalEntitiesItemsPage;
  loginPage: LoginPage;
  messagesSentToEmagizPage: MessagesSentToEmagizPage;
  processedRequestsPage: ProcessedRequestsPage;
  specialsCriteriaPage: SpecialsCriteriaPage;
  specialsHandlingPage: SpecialsHandlingPage;
  messageContext: MessageContext;
  bddTestInfo: TestInfo;
}

export interface MessageContext {
  itemId?: string;
  itmattItemId?: string;
  itmattData?: Record<string, string>;
  blacklistedAddress?: {
    name: string;
    company: string;
    senderOrReceiver: 'Sender' | 'Receiver';
  };
  predesItemIds?: string[];
  receptacleId?: string;
  responseStatus?: number;
  responseBody?: string;
}

export const testWithPages = test.extend<PageFixtures>({
  dataCompletionPage: async ({ page }, use) => {
    await use(new DataCompletionPage(page));
  },
  localEntitiesItemsPage: async ({ page }, use) => {
    await use(new LocalEntitiesItemsPage(page));
  },
  loginPage: async ({ page }, use) => {
    await use(new LoginPage(page));
  },
  messagesSentToEmagizPage: async ({ page }, use) => {
    await use(new MessagesSentToEmagizPage(page));
  },
  processedRequestsPage: async ({ page }, use) => {
    await use(new ProcessedRequestsPage(page));
  },
  specialsCriteriaPage: async ({ page }, use) => {
    await use(new SpecialsCriteriaPage(page));
  },
  specialsHandlingPage: async ({ page }, use) => {
    await use(new SpecialsHandlingPage(page));
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
