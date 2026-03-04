# Some notes on linux
- **Emacs**: Dark bar for emacs (specifically `emacs-pgtk`, pure wayland build,
on Fedora) needs the following hacky desktop entry in
`~/.local/share/applications/emacs.desktop`, namely that the exec line needs
to be replaced with: `Exec=env GTK_THEME=Adwaita:dark emacs-pgtk %F`.

- **Stow**: Now I use stow to sync my dotfiles, via the following command:
```
stow VSCodium emacs kitty mpv nvim
```

- **Blocklist**: Add the following lines to the file `/etc/hosts`:
```
0.0.0.0 youtube.com
0.0.0.0 www.youtube.com
0.0.0.0 music.youtube.com
0.0.0.0 www.music.youtube.com
0.0.0.0 reddit.com
0.0.0.0 www.reddit.com
0.0.0.0 twitch.tv
0.0.0.0 www.twitch.tv
0.0.0.0 kick.com
0.0.0.0 www.kick.com
0.0.0.0 bilibili.com
0.0.0.0 www.bilibili.com
0.0.0.0 lichess.org
0.0.0.0 www.lichess.org
0.0.0.0 chess.com
0.0.0.0 www.chess.com
0.0.0.0 everythingmoe.com
0.0.0.0 www.everythingmoe.com
0.0.0.0 animekai.to
0.0.0.0 www.animekai.to
0.0.0.0 store.steampowered.com
0.0.0.0 www.store.steampowered.com
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
