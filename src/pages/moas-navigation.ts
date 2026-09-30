import { expect, Locator, Page } from '@playwright/test';

export class MoasNavigation {
  private page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  private getVisibleMenuItem(name: string): Locator {
    return this.page.getByRole('menuitem', { name, exact: true }).filter({ visible: true }).last();
  }

  async navigateToMenuItem(name: string) {
    await expect(
      this.page.locator('.mx-underlay'),
      'The application overlay should clear before menu navigation'
    ).toBeHidden();

    const menuItem = this.getVisibleMenuItem(name);
    await expect(menuItem, `Menu item "${name}" should be visible before navigation`).toBeVisible();
    await menuItem.click();
  }

  private async openSubmenuAndSelect(parentName: string, itemName: string) {
    await this.navigateToMenuItem(parentName);

    const submenuItem = this.getVisibleMenuItem(itemName);
    await expect(
      submenuItem,
      `Submenu item "${itemName}" should be visible after opening "${parentName}"`
    ).toBeVisible();
    await submenuItem.click();
  }

  async navigateToSubmenu(parentName: string, itemName: string, pageReady: Locator) {
    if (await pageReady.isVisible()) {
      return;
    }

    await this.openSubmenuAndSelect(parentName, itemName);

    try {
      await pageReady.waitFor({ state: 'visible', timeout: 5000 });
    } catch (error) {
      if (!(error instanceof Error) || error.name !== 'TimeoutError') {
        throw error;
      }

      await this.openSubmenuAndSelect(parentName, itemName);
      await expect(
        pageReady,
        `The "${itemName}" page should be visible after selecting its menu item`
      ).toBeVisible();
    }
  }
}
