#!/bin/sh
set -eu # stop if command fails (-e), or there is undefined variable (-u)

# --- variables ---
repo="$HOME/dotfiles"
#url="https://github.com/cs1500/dotfiles.git"

# --- auto clone dotfiles ---
#git clone "$url" "$repo"
#mkdir -p "$HOME/.config/VSCodium/User"

# --- stow dotfiles ---
# use `--no-folding` to avoid symlinking entire config folders
# `-d "$repo"` tells stow to look for files in ~/dotfiles
# `-t "../directory"` specifies target location for symlinks
stow_pkg() {
    package="$1"
    target="$2"
    mkdir -p "$target"
    stow \
        --no-folding \
        -d "$repo" \
        -t "$target" \
        "$package"
}
stow_pkg "vscodium" "$HOME/.config/VSCodium"
stow_pkg "nvim" "$HOME/.config/nvim"
stow_pkg "mpv" "$HOME/.config/mpv"
stow_pkg "kitty" "$HOME/.config/kitty"
stow_pkg "emacs" "$HOME/.config/emacs"