import { Page } from '@playwright/test';

export class MoasNavigation {
  constructor(private page: Page) {}

  async navigateToMenuItem(name: string) {
    await this.page.getByRole('menuitem', { name, exact: true }).last().click();
  }

  async navigateToSubmenu(parentName: string, itemName: string) {
    await this.navigateToMenuItem(parentName);
    await this.navigateToMenuItem(itemName);
  }
}