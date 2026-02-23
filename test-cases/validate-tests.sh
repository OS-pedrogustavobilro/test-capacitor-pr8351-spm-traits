#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0
TOTAL=0

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEST_APP_DIR="$PROJECT_ROOT/test-app"
BACKUP_CONFIG="$TEST_APP_DIR/capacitor.config.ts.backup"
ORIGINAL_CONFIG="$TEST_APP_DIR/capacitor.config.ts"
GENERATED_PACKAGE="$TEST_APP_DIR/ios/App/CapApp-SPM/Package.swift"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}   SPM Package Traits Test Validator${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Function to cleanup and restore original config
cleanup() {
    local exit_code=$?
    echo ""
    echo -e "${YELLOW}Cleaning up and restoring original configuration...${NC}"

    if [ -f "$BACKUP_CONFIG" ]; then
        cp "$BACKUP_CONFIG" "$ORIGINAL_CONFIG"
        rm "$BACKUP_CONFIG"
        echo -e "${GREEN}✓ Original capacitor.config.ts restored${NC}"
    fi

    # Run sync one more time to restore the Package.swift
    cd "$TEST_APP_DIR" && npx cap sync ios > /dev/null 2>&1
    echo -e "${GREEN}✓ Package.swift restored to original state${NC}"

    exit $exit_code
}

# Set trap to ensure cleanup happens on exit, interrupt, or error
trap cleanup EXIT INT TERM

# Backup original config
echo -e "${YELLOW}Backing up original configuration...${NC}"
if [ ! -f "$ORIGINAL_CONFIG" ]; then
    echo -e "${RED}✗ Error: capacitor.config.ts not found at $ORIGINAL_CONFIG${NC}"
    exit 1
fi

cp "$ORIGINAL_CONFIG" "$BACKUP_CONFIG"
echo -e "${GREEN}✓ Backup created${NC}"
echo ""

# Function to run a test case
run_test() {
    echo "${PROJECT_ROOT}"
    local test_num=$1
    local test_name=$2
    local test_dir="$SCRIPT_DIR/$test_num-$test_name"

    TOTAL=$((TOTAL + 1))

    echo -e "${BLUE}Test $test_num: $test_name${NC}"
    echo "  Directory: $test_dir"

    # Check if test directory exists
    if [ ! -d "$test_dir" ]; then
        echo -e "${RED}  ✗ Test directory not found${NC}"
        FAILED=$((FAILED + 1))
        echo ""
        return 1
    fi

    # Check if expected Package.swift exists
    if [ ! -f "$test_dir/Package.swift" ]; then
        echo -e "${RED}  ✗ Expected Package.swift not found${NC}"
        FAILED=$((FAILED + 1))
        echo ""
        return 1
    fi

    # Check if capacitor.config.json exists
    if [ ! -f "$test_dir/capacitor.config.json" ]; then
        echo -e "${RED}  ✗ capacitor.config.json not found${NC}"
        FAILED=$((FAILED + 1))
        echo ""
        return 1
    fi

    # Copy test config to test-app (convert JSON to TS format)
    echo "  Applying test configuration..."
    cat > "$ORIGINAL_CONFIG" << 'EOF'
import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig =
EOF
    cat "$test_dir/capacitor.config.json" >> "$ORIGINAL_CONFIG"
    cat >> "$ORIGINAL_CONFIG" << 'EOF'
;

export default config;
EOF

    # Run cap sync
    echo "  Running cap sync ios..."
    cd "$TEST_APP_DIR"
    if ! npx cap sync ios > /dev/null 2>&1; then
        echo -e "${RED}  ✗ cap sync ios failed${NC}"
        FAILED=$((FAILED + 1))
        echo ""
        return 1
    fi

    # Check if Package.swift was generated
    if [ ! -f "$GENERATED_PACKAGE" ]; then
        echo -e "${RED}  ✗ Package.swift was not generated${NC}"
        FAILED=$((FAILED + 1))
        echo ""
        return 1
    fi

    # Compare generated with expected
    echo "  Comparing generated Package.swift with expected..."
    if diff -q "$GENERATED_PACKAGE" "$test_dir/Package.swift" > /dev/null 2>&1; then
        echo -e "${GREEN}  ✓ PASSED - Generated Package.swift matches expected${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}  ✗ FAILED - Generated Package.swift differs from expected${NC}"
        echo -e "${YELLOW}  Run 'diff $GENERATED_PACKAGE $test_dir/Package.swift' to see differences${NC}"
        FAILED=$((FAILED + 1))
    fi

    echo ""
    return 0
}

# Run all test cases
run_test "00" "baseline-no-traits"
run_test "01" "single-plugin-single-trait"
run_test "02" "single-plugin-multiple-traits"
run_test "03" "multiple-plugins-different-traits"
run_test "04" "all-plugins-with-traits"
run_test "05" "complex-mixed-traits"
run_test "06" "edge-case-empty-traits"
run_test "07" "defaults-trait-only"
run_test "08" "mixed-traits-with-defaults"
run_test "09" "local-path-with-traits"
run_test "10" "multiple-plugins-empty-traits"

# Print summary
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}   Test Summary${NC}"
echo -e "${BLUE}============================================${NC}"
echo -e "Total Tests:  ${TOTAL}"
echo -e "${GREEN}Passed:       ${PASSED}${NC}"
echo -e "${RED}Failed:       ${FAILED}${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed${NC}"
    exit 1
fi
