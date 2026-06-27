#!/usr/bin/env sh
# Symlinks config directories into the right location on macOS / Linux.
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

mkdir -p "$CONFIG_HOME"

link_config() {
  name="$1"
  target="$CONFIG_HOME/$name"

  # Back up a real (non-symlink) config if one exists.
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Backing up existing $target -> $target.bak"
    mv "$target" "$target.bak"
  fi

  # -s symlink, -f overwrite, -n don't dereference an existing link-to-dir
  ln -sfn "$SCRIPT_DIR/$name" "$target"
  echo "Linked $SCRIPT_DIR/$name -> $target"
}

link_config nvim
link_config yazi
