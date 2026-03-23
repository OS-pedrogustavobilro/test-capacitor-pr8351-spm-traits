import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'io.ionic.starter',
  appName: 'test-app',
  webDir: 'dist',
  experimental: {
    ios: {
    spm: {
      swiftToolsVersion: '6.1',
      packageTraits: {
        '@ospedrobilro/cap-plugin-with-traits': ['.defaults', 'ExtendedFeatures', 'Analytics'],
        '@capacitor/haptics': []
      }
    }
  }
  }
};

export default config;
