#!/bin/bash
set -e

echo "==> Видалення старих NVIDIA-драйверів..."
sudo pacman -Rns --noconfirm nvidia nvidia-utils nvidia-settings || true

echo "==> Встановлення nvidia-dkms, headers і утиліт..."
sudo pacman -Syu --noconfirm nvidia-dkms nvidia-utils nvidia-settings linux-zen-headers dkms

echo "==> Відновлення mkinitcpio.conf з підтримкою NVIDIA..."
sudo tee /etc/mkinitcpio.conf > /dev/null <<EOF
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
BINARIES=()
FILES=()
HOOKS=(base udev autodetect modconf block keyboard keymap filesystems fsck)
EOF

echo "==> Збирання модулів через dkms..."
sudo dkms autoinstall

echo "==> Оновлення initramfs..."
sudo mkinitcpio -P

echo "==> Додавання nvidia_drm.modeset=1 до GRUB..."
if grep -q "nvidia_drm.modeset=1" /etc/default/grub; then
  echo "  (GRUB вже містить параметр)"
else
  sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& nvidia_drm.modeset=1/' /etc/default/grub
fi

echo "==> Генерація GRUB-конфігурації..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "==> Перевірка наявності модулів NVIDIA..."
MOD_DIR="/usr/lib/modules/$(uname -r)/kernel/drivers/video"
if ls $MOD_DIR | grep -qi nvidia; then
  echo "✅ NVIDIA-модулі успішно зібрані!"
else
  echo "❌ Модулі не знайдені. Можливо, збірка не вдалася."
fi

echo "==> Готово. Перезавантаж систему для активації драйвера."