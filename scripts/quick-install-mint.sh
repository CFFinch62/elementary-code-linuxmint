#!/bin/bash
# Backward compatibility wrapper for quick-install-mint.sh
# Redirects to the new location

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Note: This script has moved to distros/linux-mint/quick-install.sh"
echo "Redirecting..."
echo ""

exec bash "$PROJECT_ROOT/distros/linux-mint/quick-install.sh" "$@"
