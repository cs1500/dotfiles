#!/bin/sh
set -eu

# --- variables ---
repo="$HOME/dotfiles"

# --- unstow dotfiles ---
# `-D` means delete the symlinks created by stow
unstow_pkg() {
    package="$1"
    target="$2"

    stow \
        -D \
        --no-folding \
        -d "$repo" \
        -t "$target" \
        "$package"
}

unstow_pkg "vscodium" "$HOME/.config/VSCodium"
unstow_pkg "nvim" "$HOME/.config/nvim"
unstow_pkg "mpv" "$HOME/.config/mpv"
unstow_pkg "kitty" "$HOME/.config/kitty"
unstow_pkg "emacs" "$HOME/.config/emacs"
unstow_pkg "desktop-entries" "$HOME/.local/share/applications"