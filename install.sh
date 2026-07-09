#!/usr/bin/env sh
# Symlinks config directories into the right location on macOS / Linux.
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

mkdir -p "$CONFIG_HOME"

link_file() {
  src="$1"
  target="$2"

  # Back up a real (non-symlink) config if one exists.
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Backing up existing $target -> $target.bak"
    mv "$target" "$target.bak"
  fi

  # -s symlink, -f overwrite, -n don't dereference an existing link-to-dir
  ln -sfn "$src" "$target"
  echo "Linked $src -> $target"
}

link_config() {
  name="$1"
  link_file "$SCRIPT_DIR/$name" "$CONFIG_HOME/$name"
}

link_config nvim
link_config yazi
link_config kitty
link_config tmux
link_config opencode

link_file "$SCRIPT_DIR/starship/starship.toml" "$CONFIG_HOME/starship.toml"
link_file "$SCRIPT_DIR/zsh/zshrc" "$HOME/.zshrc"
