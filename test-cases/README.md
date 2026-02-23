# Package.swift Test Files for PR #8351

This document lists all Package.swift test files generated for testing the SPM package traits functionality.

## Quick Reference

| Test Case | Swift Tools Version | Traits Config | File Path |
|-----------|-------------------|---------------|-----------|
| Baseline | 5.9 | None | `00-baseline-no-traits/Package.swift` |
| Single Plugin, Single Trait | 6.1 | status-bar: PrivacyManifest | `01-single-plugin-single-trait/Package.swift` |
| Single Plugin, Multiple Traits | 6.1 | status-bar: PrivacyManifest, SwiftConcurrency | `02-single-plugin-multiple-traits/Package.swift` |
| Multiple Plugins, Different Traits | 6.1 | status-bar: PrivacyManifest, app: SwiftConcurrency | `03-multiple-plugins-different-traits/Package.swift` |
| All Plugins with Traits | 6.1 | All plugins: PrivacyManifest | `04-all-plugins-with-traits/Package.swift` |
| Complex Mixed Traits | 6.1 | Mixed configurations | `05-complex-mixed-traits/Package.swift` |
| Edge Case: Empty Traits | 6.1 | status-bar: [] (renders with NO traits parameter) | `06-edge-case-empty-traits/Package.swift` |
| Defaults Trait Only | 6.1 | status-bar: .defaults | `07-defaults-trait-only/Package.swift` |
| Mixed Traits with Defaults | 6.1 | status-bar: .defaults + strings | `08-mixed-traits-with-defaults/Package.swift` |
| Local Path with Traits | 6.1 | Local plugin with .defaults + strings | `09-local-path-with-traits/Package.swift` |
| Multiple Plugins Empty Traits | 6.1 | Mixed: some traits, some [], some omitted | `10-multiple-plugins-empty-traits/Package.swift` |

## Test Files

### 1. Baseline (No Traits)
**File:** `test-cases/00-baseline-no-traits/Package.swift`
**Config:** N/A
```
swift-tools-version: 5.9
No traits in any dependencies
```

### 2. Single Plugin, Single Trait
**File:** `test-cases/01-single-plugin-single-trait/Package.swift`
**Config:** `test-cases/01-single-plugin-single-trait/capacitor.config.json`
```
swift-tools-version: 6.1
@capacitor/status-bar → traits: ["PrivacyManifest"]
```

### 3. Single Plugin, Multiple Traits
**File:** `test-cases/02-single-plugin-multiple-traits/Package.swift`
**Config:** `test-cases/02-single-plugin-multiple-traits/capacitor.config.json`
```
swift-tools-version: 6.1
@capacitor/status-bar → traits: ["PrivacyManifest", "SwiftConcurrency"]
```

### 4. Multiple Plugins, Different Traits
**File:** `test-cases/03-multiple-plugins-different-traits/Package.swift`
**Config:** `test-cases/03-multiple-plugins-different-traits/capacitor.config.json`
```
swift-tools-version: 6.1
@capacitor/status-bar → traits: ["PrivacyManifest"]
@capacitor/app → traits: ["SwiftConcurrency"]
```

### 5. All Plugins with Traits
**File:** `test-cases/04-all-plugins-with-traits/Package.swift`
**Config:** `test-cases/04-all-plugins-with-traits/capacitor.config.json`
```
swift-tools-version: 6.1
All 4 plugins → traits: ["PrivacyManifest"]
```

### 6. Complex Mixed Traits
**File:** `test-cases/05-complex-mixed-traits/Package.swift`
**Config:** `test-cases/05-complex-mixed-traits/capacitor.config.json`
```
swift-tools-version: 6.1
@capacitor/status-bar → traits: ["PrivacyManifest", "SwiftConcurrency", "Debug"]
@capacitor/app → traits: ["PrivacyManifest"]
@capacitor/haptics → no traits
@capacitor/keyboard → traits: ["SwiftConcurrency", "Testing"]
```

### 7. Edge Case: Empty Traits Array
**File:** `test-cases/06-edge-case-empty-traits/Package.swift`
**Config:** `test-cases/06-edge-case-empty-traits/capacitor.config.json`
```
swift-tools-version: 6.1
@capacitor/status-bar → traits: [] (config has empty array, but NO traits parameter in Package.swift)
```

### 8. Defaults Trait Only
**File:** `test-cases/07-defaults-trait-only/Package.swift`
**Config:** `test-cases/07-defaults-trait-only/capacitor.config.json`
```
swift-tools-version: 6.1
@capacitor/status-bar → traits: [.defaults]
Note: .defaults is rendered as Swift enum case (no quotes)
```

### 9. Mixed Traits with Defaults
**File:** `test-cases/08-mixed-traits-with-defaults/Package.swift`
**Config:** `test-cases/08-mixed-traits-with-defaults/capacitor.config.json`
```
swift-tools-version: 6.1
@capacitor/status-bar → traits: [.defaults, "ExtendedFeatures", "Analytics"]
Note: .defaults renders without quotes, strings render with quotes
```

### 10. Local Path with Traits
**File:** `test-cases/09-local-path-with-traits/Package.swift`
**Config:** `test-cases/09-local-path-with-traits/capacitor.config.json`
```
swift-tools-version: 6.1
@ospedrobilro/cap-plugin-with-traits → path: "...", traits: [.defaults, "ExtendedFeatures", "Analytics"]
@capacitor/haptics → path: "...", traits: [] (config has empty array, renders with NO traits parameter)
Note: Tests local path dependencies with traits
```

### 11. Multiple Plugins with Empty Traits
**File:** `test-cases/10-multiple-plugins-empty-traits/Package.swift`
**Config:** `test-cases/10-multiple-plugins-empty-traits/capacitor.config.json`
```
swift-tools-version: 6.1
@capacitor/status-bar → traits: ["PrivacyManifest"]
@capacitor/app → traits: [] (config has empty array, renders with NO traits parameter)
@capacitor/haptics → not in config (renders with NO traits parameter)
@capacitor/keyboard → traits: ["SwiftConcurrency"]
Note: Tests that empty arrays and missing config both result in no traits parameter
```

## Validation Checklist

For each test case, verify:

- [ ] Swift tools version is correct (5.9 without traits, 6.1 with traits)
- [ ] Plugins with configured traits have `traits:` parameter in their `.package()` line
- [ ] Plugins without configured traits do NOT have `traits:` parameter
- [ ] **Plugins with empty array `[]` in config do NOT have `traits:` parameter** (critical fix in test 06)
- [ ] Trait arrays contain exactly the expected trait names
- [ ] `.defaults` trait is rendered as `.defaults` (Swift enum case, no quotes)
- [ ] String traits are properly quoted (e.g., `"PrivacyManifest"`)
- [ ] Mixed `.defaults` and string traits are correctly formatted (e.g., `[.defaults, "Feature"]`)
- [ ] Multiple traits are comma-separated within the array
- [ ] Local path dependencies with traits use `path:` parameter correctly
- [ ] Package structure and other elements remain unchanged

## Running Tests

To test each configuration:

```bash
# 1. Navigate to your Capacitor project
cd test-app

# 2. Copy a test config (example for test case 1)
cp ../test-cases/01-single-plugin-single-trait/capacitor.config.json ./

# 3. Generate Package.swift
npx cap sync ios

# 4. Compare generated with expected
diff ios/App/CapApp-SPM/Package.swift ../test-cases/01-single-plugin-single-trait/Package.swift
```

## Expected vs Actual Comparison

Use this script to compare all test cases:

```bash
#!/bin/bash
for i in {0..10}; do
  case_dir=$(printf "%02d-*" $i | ls -d test-cases/$case_dir 2>/dev/null | head -1)
  if [ -d "$case_dir" ]; then
    echo "Testing: $case_dir"
    # Your comparison logic here
  fi
done
```

## Key Testing Scenarios Covered

### Basic Functionality (Tests 00-06)
- Baseline without traits support (Swift 5.9)
- Single and multiple string traits
- Multiple plugins with different traits
- Empty traits array edge case

### Advanced Features (Tests 07-10)
- **Test 07**: `.defaults` special trait (Swift enum case)
- **Test 08**: Mixed `.defaults` and string traits
- **Test 09**: Local path dependencies with traits (matches actual implementation)
- **Test 10**: Multiple plugins with mixed empty/non-empty trait configurations

### Critical Behaviors Validated
1. Empty array `[]` in config results in NO `traits:` parameter (not `traits: []`)
2. `.defaults` renders without quotes as Swift enum case
3. String traits render with quotes
4. Local path dependencies support traits
5. Plugins not in config have no traits parameter
