# test-capacitor-pr8351-spm-traits

Repository to test functionality to add SPM Traits of [PR 8351](https://github.com/ionic-team/capacitor/pull/8351) in capacitor repo, build with the help of Claude.

## Steps

1. Clone the fork with the feature into your machine: https://github.com/robingenz/ionic-team-capacitor

1. Checkout branch `feat/spm-package-traits`

1. Install and build core / cli

1. In this repo, point the Capacitor framework dependencies in `cap-plugin-with-traits` and `test-app` to the local folder containing the fork 

1. Install dependencies and build the plugin, then also do the same for the app + run cap sync for the app

1. Run the app on an iOS device. You should be able to see some `[PluginWithTraits]` logs, because of the enabled traits.

1. You may also run some automated tests by doing `cd test-cases; ./validate-tests.sh`. Refer to the [test case README](./test-cases/README.md) for more information on the tests.
