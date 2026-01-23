#!/bin/bash
# Backward compatibility wrapper for install.sh
# Redirects to the new location

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Note: This script has moved to scripts/common/install.sh"
echo "Redirecting..."
echo ""

exec bash "$SCRIPT_DIR/common/install.sh" "$@"
