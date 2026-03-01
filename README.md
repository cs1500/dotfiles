# Some notes on linux
- **Emacs**: Dark bar for emacs (specifically `emacs-pgtk`, pure wayland build,
on Fedora) needs the following hacky desktop entry in
`~/.local/share/applications/emacs.desktop`, namely that the exec line needs
to be replaced with: `Exec=env GTK_THEME=Adwaita:dark emacs-pgtk %F`.

- **Stow**: Now I use stow to sync my dotfiles, via the following command:
```
stow VSCodium emacs kitty mpv nvim
```

## Debian
For Nvidia hybrid systems, Debian 12 works. After fresh install
run:
```
sudo apt install firmware-linux firmware-misc-nonfree
```

## Fedora
Great experience on Fedora 43. Apps I use include:
```
sudo dnf install \
    mpv vlc \
    syncthing stow \
    kitty neovim emacs R \
    texlive-scheme-full \
    fira-code-fonts dnf-plugins-core
```
