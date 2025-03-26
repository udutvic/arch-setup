#!/bin/bash
# Arch + Hyprland + React Native Setup Script

set -e

echo "[1/10] Оновлення системи..."
sudo pacman -Syu --noconfirm

echo "[2/10] Встановлення базових пакетів..."
sudo pacman -S --noconfirm git base-devel xorg wayland hyprland xdg-desktop-portal-hyprland \
  foot waybar sddm sddm-kcm networkmanager xdg-utils wl-clipboard qt5-wayland qt6-wayland gtk3 \
  ttf-jetbrains-mono ttf-font-awesome noto-fonts noto-fonts-emoji brightnessctl pavucontrol neofetch thunar xfce4-terminal rofi flameshot xclip

echo "[3/10] Увімкнення сервісів..."
sudo systemctl enable sddm
sudo systemctl enable NetworkManager

echo "[4/10] Налаштування Hyprland..."
mkdir -p ~/.config/hypr
cp -r /etc/xdg/hypr/* ~/.config/hypr/ || true
echo -e '\n# Hyprland session' >> ~/.bash_profile
echo 'export XDG_SESSION_TYPE=wayland' >> ~/.bash_profile
echo 'export GDK_BACKEND=wayland,x11' >> ~/.bash_profile
echo 'export QT_QPA_PLATFORM=wayland;xcb' >> ~/.bash_profile
echo 'export MOZ_ENABLE_WAYLAND=1' >> ~/.bash_profile
echo 'exec Hyprland' >> ~/.bash_profile

echo "[5/10] Встановлення yay..."
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay && makepkg -si --noconfirm
cd ~ && rm -rf ~/yay

echo "[8/10] Встановлення Android Studio, VS Code, Java..."
sudo pacman -S --noconfirm jdk17-openjdk
yay -S --noconfirm android-studio visual-studio-code-bin

echo "[9/10] Додавання змінних середовища Android SDK..."
echo -e '\n# Android SDK' >> ~/.bashrc
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH' >> ~/.bashrc

echo "[10/10] Установка завершена!"
echo "Перезавантажте систему і увійдіть у середовище Hyprland."
