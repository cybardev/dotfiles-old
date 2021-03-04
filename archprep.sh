#!/bin/sh
# Script to prepare an Arch installation with my dotfiles

# install make dependencies for yay
pacman -Syyu sudo git base-devel make go --noconfirm

# install yay
cd /opt/
git clone https://aur.archlinux.org/yay.git
chown -R $(id -u -n):$(id -u -n) ./yay-git
cd /yay-git/
makepkg -si

# install required packages
yay -S --noconfirm rofi xorg xorg-xprop lightdm kitty ranger thunar neovim python-pynvim awesome-git light-git picom-tryone-git inter-font alsa-utils pulseaudio pulseaudio-alsa acpi acpid acpi_call mpd mpc mpv maim feh xclip imagemagick blueman redshift upower xfce4-power-manager noto-fonts-emoji xdg-user-dirs iproute2 iw ffmpeg firefox ncmpcpp lxappearance mousepad lightdm-webkit2-greeter lightdm-webkit2-theme-glorious
systemctl enable lightdm pamac-all curl wget bash lxpolkit-git

# set up rice
cd ~/
git clone --depth 1 https://github.com/manilarome/the-glorious-dotfiles/
mkdir -p $HOME/.config/awesome
cp -r the-glorious-dotfiles/config/awesome/surreal $HOME/.config/awesome
curl -fsSL https://raw.githubusercontent.com/manilarome/blurredfox/script/install.sh | bash -s -- stable
git clone https://github.com/cybarspace/dotfiles.git
cd ./dotfiles/
cp -r ./icons/* $HOME/.icons/
cp -r ./themes/* $HOME/.themes/
cp -r ./fonts/* $HOME/.fonts/
cp -r ./kitty/* $HOME/.config/kitty/
cp -r ./neofetch/* $HOME/.config/neofetch/
cp -r ./face $HOME/.face

# display instructions on what to do next
echo 0) Edit this file ~/.config/awesome/configuration/config.lua
echo 1) Edit /etc/lightdm/lightdm.conf
echo -> Set greeter-session=lightdm-webkit2-greeter under the [Seat:*] section.
echo 2) Edit /etc/lightdm/lightdm-webkit2-greeter.conf
echo -> Set webkit_theme=glorious and debug_mode=true. 
echo 3) Reboot
