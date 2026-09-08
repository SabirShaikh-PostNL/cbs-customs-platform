import { Page, expect } from '@playwright/test';
import { getConfig } from '@/config/config';

export class LoginPage {
  private config = getConfig();

  constructor(private page: Page) {}

  async navigate() {
    await this.page.goto(this.config.moasUrl);
    await expect(
      this.page.locator('#usernameInput')
    ).toBeVisible();
  }

  async login() {
    await this.page.fill(
      '#usernameInput',
      this.config.moasUser
    );

    await this.page.fill(
      '#passwordInput',
      this.config.moasPassword
    );

    await this.page.click('#loginButton');
  }

  async verifyLoggedIn() {
    await this.page.waitForLoadState('networkidle');
  }
}