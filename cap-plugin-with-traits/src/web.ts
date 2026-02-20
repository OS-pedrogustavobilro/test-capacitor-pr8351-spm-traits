import { WebPlugin } from '@capacitor/core';

import type { PluginWithTraitsPlugin } from './definitions';

export class PluginWithTraitsWeb extends WebPlugin implements PluginWithTraitsPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
