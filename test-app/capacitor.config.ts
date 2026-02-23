import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'io.ionic.starter',
  appName: 'test-app',
  webDir: 'dist',
  ios: {
    spm: {
      packageTraits: {
        '@ospedrobilro/cap-plugin-with-traits': ['ExtendedFeatures', 'Analytics']
      }
    }
  }
};

export default config;
