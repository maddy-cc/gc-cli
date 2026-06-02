#!/usr/bin/env bash
set -euo pipefail

REPO_RAW_URL="https://raw.githubusercontent.com/maddy-cc/gc-cli/main"
INSTALL_DIR="${GC_INSTALL_DIR:-$HOME/.local/bin}"
TARGET="$INSTALL_DIR/gc"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_GC="$SCRIPT_DIR/bin/gc"

mkdir -p "$INSTALL_DIR"

if [ "${BASH_SOURCE[0]}" != "bash" ] && [ -f "$LOCAL_GC" ]; then
  cp "$LOCAL_GC" "$TARGET"
else
  if ! command -v curl >/dev/null 2>&1; then
    echo "install failed: curl is required" >&2
    exit 1
  fi
  curl -fsSL "$REPO_RAW_URL/bin/gc" -o "$TARGET"
fi

chmod +x "$TARGET"

echo "gc installed: $TARGET"

case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    echo
    echo "warning: $INSTALL_DIR is not in PATH."
    echo "Add this line to your shell profile, then restart the terminal:"
    echo
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    ;;
esac

echo
"$TARGET" --help >/dev/null
echo "done"
