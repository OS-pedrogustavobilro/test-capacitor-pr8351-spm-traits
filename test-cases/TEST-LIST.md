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
| Edge Case: Empty Traits | 6.1 | status-bar: [] | `06-edge-case-empty-traits/Package.swift` |

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
@capacitor/status-bar → traits: []
```

## Validation Checklist

For each test case, verify:

- [ ] Swift tools version is correct (5.9 without traits, 6.1 with traits)
- [ ] Plugins with configured traits have `traits:` parameter in their `.package()` line
- [ ] Plugins without configured traits do NOT have `traits:` parameter
- [ ] Trait arrays contain exactly the expected trait names
- [ ] Trait names are properly quoted as strings
- [ ] Multiple traits are comma-separated within the array
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
diff ios/App/Package.swift ../test-cases/01-single-plugin-single-trait/Package.swift
```

## Expected vs Actual Comparison

Use this script to compare all test cases:

```bash
#!/bin/bash
for i in {0..6}; do
  case_dir=$(printf "%02d-*" $i | ls -d test-cases/$case_dir 2>/dev/null | head -1)
  if [ -d "$case_dir" ]; then
    echo "Testing: $case_dir"
    # Your comparison logic here
  fi
done
```
