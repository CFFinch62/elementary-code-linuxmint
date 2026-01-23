#!/bin/bash
# Backward compatibility wrapper for build.sh
# Redirects to the new location

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Note: This script has moved to scripts/common/build.sh"
echo "Redirecting..."
echo ""

exec bash "$SCRIPT_DIR/common/build.sh" "$@"
