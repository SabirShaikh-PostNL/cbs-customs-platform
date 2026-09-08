import { APIRequestContext } from '@playwright/test';
import { getConfig } from '@/config/config';

export class PredesApi {
  private request: APIRequestContext;

  constructor(request: APIRequestContext) {
    this.request = request;
  }

  async sendPredes(payload: object) {
    const { predesUrl, apiKey } = getConfig();
    return await this.request.post(predesUrl, {
      headers: {
        'x-api-key': apiKey,
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      data: JSON.stringify(payload),
    });
  }
}
