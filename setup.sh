#!/bin/bash
set -e

echo "==> Видалення старих NVIDIA-драйверів..."
sudo pacman -Rns --noconfirm nvidia nvidia-utils nvidia-settings || true

echo "==> Встановлення nvidia-dkms та супутніх пакетів..."
sudo pacman -Syu --noconfirm nvidia-dkms nvidia-utils nvidia-settings

echo "==> Відновлення mkinitcpio.conf з підтримкою NVIDIA..."
sudo tee /etc/mkinitcpio.conf > /dev/null <<EOF
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
BINARIES=()
FILES=()
HOOKS=(base udev autodetect modconf block keyboard keymap filesystems fsck)
EOF

echo "==> Генерація initramfs..."
sudo mkinitcpio -P

echo "==> Додавання параметра до GRUB..."
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& nvidia_drm.modeset=1/' /etc/default/grub

echo "==> Оновлення GRUB..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "==> Готово. Перезавантаж компʼютер."