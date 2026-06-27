#!/usr/bin/env sh
# Symlinks nvim/ into the right config location on macOS / Linux.
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
TARGET="$CONFIG_HOME/nvim"

mkdir -p "$CONFIG_HOME"

# Back up a real (non-symlink) config if one exists.
if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
  echo "Backing up existing $TARGET -> $TARGET.bak"
  mv "$TARGET" "$TARGET.bak"
fi

# -s symlink, -f overwrite, -n don't dereference an existing link-to-dir
ln -sfn "$SCRIPT_DIR/nvim" "$TARGET"
echo "Linked $SCRIPT_DIR/nvim -> $TARGET"
