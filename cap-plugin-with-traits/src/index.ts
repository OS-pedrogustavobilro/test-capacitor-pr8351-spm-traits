import { registerPlugin } from '@capacitor/core';

import type { PluginWithTraitsPlugin } from './definitions';

const PluginWithTraits = registerPlugin<PluginWithTraitsPlugin>('PluginWithTraits', {
  web: () => import('./web').then((m) => new m.PluginWithTraitsWeb()),
});

export * from './definitions';
export { PluginWithTraits };
