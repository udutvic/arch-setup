# /etc/mkinitcpio.conf

## Завантажуємо модулі NVIDIA (dkms)
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)

## Додаткові виконувані файли — залишаємо порожнім
BINARIES=()

## Додаткові файли — залишаємо порожнім
FILES=()

## HOOKS — порядок має значення!
HOOKS=(
  base
  udev
  autodetect
  modconf
  block
  keyboard
  keymap
  filesystems
  fsck
)