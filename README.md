# Setup instructions
- **Stow**:
Run the following to symlink:
```
bash ./install.sh
```
and the following to unsymlink:
```
bash ./uninstall.sh
```

## Ubuntu
Install applications with:
```
sudo apt install \
    fastfetch htop nvtop mpv vlc ranger syncthing stow \
    kitty neovim git curl fonts-firacode texlive-full \
    r-base r-base-dev \
    gnome-shell-extensions gnome-shell-extension-manager \
    emacs-lucid elpa-pdf-tools elpa-pdf-tools-server elpa-evil \
    elpa-emacs-dashboard auctex elpa-eglot texlab elpa-corfu \
    elpa-magit python3-pylsp
```

## Debian
For older Nvidia hybrid systems, Debian 12 works. This has been
tested with Nvidia proprietary drivers 535.261.03, on GNOME 43.9 with X11
session and kernel 6.1.0-43-amd64. The system has been stable after many
resume cycles, although long sessions will cause desktop performance to
degrade.

Using Debian 13 with Nvidia proprietary drivers 595.45.04 from the Nvidia 
repository works on the Wayland session, on GNOME 48.7.
![](archive/showcase/show_d13_fastfetch.png)

To add a user to sudoers list, run the following, then reboot the system:
```
su -
usermod -a -G sudo user
```
Install applications with:
```
sudo apt install \
    fastfetch htop nvtop mpv vlc ranger syncthing stow \
    linux-headers-generic firmware-linux firmware-misc-nonfree dkms \
    kitty neovim git curl fonts-firacode texlive-full \
    r-base r-base-dev \
    gnome-shell-extensions gnome-shell-extension-manager \
    emacs elpa-pdf-tools elpa-pdf-tools-server elpa-evil \
    elpa-emacs-dashboard auctex
```

## Fedora
Great experience on Fedora 43, although for Nvidia systems, LTS distributions
are preferred. Install applications with:
```
sudo dnf install \
    mpv vlc ranger \
    fastfetch syncthing stow htop \
    kitty neovim emacs R fira-code-fonts \
    texlive-scheme-full gnome-extensions-app
```
- **Emacs**: Dark bar for emacs (specifically `emacs-pgtk`, pure wayland build,
on Fedora) needs the following hacky desktop entry in
`~/.local/share/applications/emacs.desktop`, namely that the exec line needs
to be replaced with: `Exec=env GTK_THEME=Adwaita:dark emacs-pgtk %F`.

To always show GRUB on boot, run:
```
sudo grub2-editenv - unset menu_auto_hide
```
Add the following lines to `/etc/default/grub` to list other installed operating
systems:
```
GRUB_TIMEOUT_STYLE=menu
GRUB_DISABLE_OS_PROBER=false
```
Then update grub with:
```
sudo grub2-mkconfig -o /etc/grub2-efi.cfg
```

# Blocklist
```
0.0.0.0 youtube.com
0.0.0.0 www.youtube.com
0.0.0.0 music.youtube.com
0.0.0.0 www.music.youtube.com
0.0.0.0 bilibili.com
0.0.0.0 www.bilibili.com
0.0.0.0 reddit.com
0.0.0.0 www.reddit.com
0.0.0.0 chess.com
0.0.0.0 www.chess.com
0.0.0.0 lichess.org
0.0.0.0 www.lichess.org
0.0.0.0 everythingmoe.com
0.0.0.0 www.everythingmoe.com
0.0.0.0 anikototv.to
0.0.0.0 www.anikototv.to
0.0.0.0 animepahe.pw
0.0.0.0 www.animepahe.pw
0.0.0.0 phoronix.com
0.0.0.0 www.phoronix.com
0.0.0.0 notebookcheck.net
0.0.0.0 www.notebookcheck.net
0.0.0.0 store.steampowered.com
0.0.0.0 www.store.steampowered.com
```

# References
- https://wiki.debian.org/InstallingDebianOn/Dell/ProMaxMA16250
- https://docs.nvidia.com/datacenter/tesla/driver-installation-guide/debian.html#
- https://cran.r-project.org/bin/linux/debian/#secure-apt