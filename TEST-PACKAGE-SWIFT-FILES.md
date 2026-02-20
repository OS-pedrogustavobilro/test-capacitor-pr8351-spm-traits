# Test Package.swift Files for PR #8351

## Summary

This repository contains **7 test Package.swift files** to validate the functionality added by [Capacitor PR #8351](https://github.com/ionic-team/capacitor/pull/8351), which introduces SPM package traits support.

## What PR #8351 Adds

- **New config option**: `ios.spm.packageTraits` to specify traits for SPM plugin dependencies
- **Automatic version upgrade**: Uses `swift-tools-version: 6.1` when traits are configured (otherwise stays on `5.9`)
- **Traits injection**: Appends `traits: [...]` to `.package()` dependency declarations

## Test Files Overview

All test files are located in the `test-cases/` directory:

```
test-cases/
├── README.md                                    # Detailed documentation
├── TEST-LIST.md                                 # Quick reference table
├── 00-baseline-no-traits/
│   └── Package.swift                           # Baseline (no traits)
├── 01-single-plugin-single-trait/
│   ├── Package.swift                           # 1 plugin, 1 trait
│   └── capacitor.config.json
├── 02-single-plugin-multiple-traits/
│   ├── Package.swift                           # 1 plugin, multiple traits
│   └── capacitor.config.json
├── 03-multiple-plugins-different-traits/
│   ├── Package.swift                           # Multiple plugins, different traits
│   └── capacitor.config.json
├── 04-all-plugins-with-traits/
│   ├── Package.swift                           # All plugins with same trait
│   └── capacitor.config.json
├── 05-complex-mixed-traits/
│   ├── Package.swift                           # Complex mixed scenario
│   └── capacitor.config.json
└── 06-edge-case-empty-traits/
    ├── Package.swift                           # Edge case: empty traits array
    └── capacitor.config.json
```

## Quick Test Matrix

| # | Test Case | swift-tools-version | Plugins with Traits |
|---|-----------|--------------------|--------------------|
| 0 | Baseline | 5.9 | None |
| 1 | Single plugin, single trait | 6.1 | status-bar (1 trait) |
| 2 | Single plugin, multiple traits | 6.1 | status-bar (2 traits) |
| 3 | Multiple plugins, different traits | 6.1 | status-bar, app |
| 4 | All plugins with traits | 6.1 | All 4 plugins |
| 5 | Complex mixed traits | 6.1 | 3 of 4 plugins (varied) |
| 6 | Edge case: empty traits | 6.1 | status-bar (empty array) |

## Key Differences to Test

### Swift Tools Version
- **Without traits**: `// swift-tools-version: 5.9`
- **With traits**: `// swift-tools-version: 6.1`

### Dependency Declaration
- **Without traits**:
  ```swift
  .package(url: "https://github.com/ionic-team/capacitor-status-bar.git", from: "8.0.0")
  ```

- **With traits**:
  ```swift
  .package(url: "https://github.com/ionic-team/capacitor-status-bar.git", from: "8.0.0", traits: ["PrivacyManifest"])
  ```

## How to Use These Test Files

### Option 1: Manual Validation
Compare your generated Package.swift against the expected files:

```bash
# Generate with PR #8351 applied
cd test-app
cp ../test-cases/01-single-plugin-single-trait/capacitor.config.json ./
npx cap sync ios

# Compare
diff ios/App/Package.swift ../test-cases/01-single-plugin-single-trait/Package.swift
```

### Option 2: Automated Testing Script

```bash
#!/bin/bash
# test-pr8351.sh

for test_dir in test-cases/*/; do
  test_name=$(basename "$test_dir")

  if [ -f "$test_dir/capacitor.config.json" ]; then
    echo "Testing: $test_name"

    # Copy config
    cp "$test_dir/capacitor.config.json" test-app/

    # Generate Package.swift
    cd test-app && npx cap sync ios && cd ..

    # Compare
    if diff -q "test-app/ios/App/Package.swift" "$test_dir/Package.swift" > /dev/null; then
      echo "✅ PASS: $test_name"
    else
      echo "❌ FAIL: $test_name"
      diff "test-app/ios/App/Package.swift" "$test_dir/Package.swift"
    fi

    echo "---"
  fi
done
```

### Option 3: Visual Inspection
Simply open the Package.swift files and verify:
1. Correct swift-tools-version (5.9 vs 6.1)
2. Presence/absence of `traits:` parameter
3. Correct trait names in arrays
4. Proper formatting and syntax

## Common Traits Used in Tests

- **PrivacyManifest**: Includes privacy manifest resources (iOS requirement)
- **SwiftConcurrency**: Enables Swift concurrency features
- **Debug**: Debug-specific features
- **Testing**: Testing utilities and helpers

## Validation Checklist

For each test file, verify:

- [ ] Swift tools version matches expected (5.9 or 6.1)
- [ ] Plugins with configured traits have `traits:` parameter
- [ ] Plugins without traits do NOT have `traits:` parameter
- [ ] Trait arrays contain correct trait names (case-sensitive)
- [ ] Array syntax is correct: `["Trait1", "Trait2"]`
- [ ] No regression in other Package.swift elements

## Documentation

- **Detailed guide**: See `test-cases/README.md`
- **Quick reference**: See `test-cases/TEST-LIST.md`
- **PR details**: https://github.com/ionic-team/capacitor/pull/8351
- **Related issue**: https://github.com/ionic-team/capacitor/issues/8335

## Plugin Dependencies Used

All test files use these Capacitor plugins:
- `@capacitor/app` (v8.0.1)
- `@capacitor/status-bar` (v8.0.1)
- `@capacitor/haptics` (v8.0.0)
- `@capacitor/keyboard` (v8.0.0)

## Next Steps

1. Apply PR #8351 to your Capacitor CLI
2. Test each configuration using the provided capacitor.config.json files
3. Compare generated Package.swift files with the expected test files
4. Report any discrepancies or issues
5. Verify builds succeed in Xcode with the generated Package.swift files

## Notes

- Package traits require Swift 6.1+, hence the version upgrade when traits are present
- Empty traits arrays (`[]`) should still trigger the version upgrade
- Invalid trait names will be ignored by SPM (no error thrown)
- Traits must be defined in the package's manifest to have any effect
