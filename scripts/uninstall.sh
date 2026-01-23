#!/bin/bash
# Backward compatibility wrapper for uninstall.sh
# Redirects to the new location

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Note: This script has moved to scripts/common/uninstall.sh"
echo "Redirecting..."
echo ""

exec bash "$SCRIPT_DIR/common/uninstall.sh" "$@"
