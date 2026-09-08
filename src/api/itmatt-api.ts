import { APIRequestContext } from '@playwright/test';
import { getConfig } from '@/config/config';

export class ItmattApi {
  private request: APIRequestContext;

  constructor(request: APIRequestContext) {
    this.request = request;
  }

  async sendItmatt(xmlPayload: string) {
    const { itmattUrl, apiKey } = getConfig();
    return await this.request.post(itmattUrl, {
      headers: {
        'x-api-key': apiKey,
        'Content-Type': 'application/xml',
      },
      data: xmlPayload,
    });
  }
}
