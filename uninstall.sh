#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${GC_INSTALL_DIR:-$HOME/.local/bin}"
TARGET="$INSTALL_DIR/gc"

if [ -f "$TARGET" ]; then
  rm "$TARGET"
  echo "gc removed: $TARGET"
else
  echo "gc is not installed at: $TARGET"
fi

echo
echo "User data was not removed:"
echo "  $HOME/.gc-branch-log.jsonl"
echo "  $HOME/.gc-config.json"
