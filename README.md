### Some notes on linux

- For Debian systems, often need to run: `apt install firmware-linux
firmware-misc-nonfree` after fresh install. Right now not good experience
for Nvidia hybrid systems, Debian 12 works, but for me it's packages are
too out of date.

- Dark bar for emacs (specifically `emacs-pgtk`, pure wayland build) needs
the following hacky desktop entry in
`~/.local/share/applications/emacs.desktop`, namely that the exec line needs
to be replaced with: `Exec=env GTK_THEME=Adwaita:dark emacs-pgtk %F`.

- Now I use stow to symlink my maintained dotfiles.
```
stow emacs kitty nvim
```