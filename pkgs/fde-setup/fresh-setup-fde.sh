#!/bin/sh

set -ex

# setup disk
echo "EFI_PART="
lsblk
read EFI_PART

echo "LUKS_PART="
lsblk
read LUKS_PART

EFI_MNT=/root/boot
mkdir -p "$EFI_MNT"
mkfs.vfat -F 32 -n BOOT "$EFI_PART"
mount "$EFI_PART" "$EFI_MNT"

cryptsetup luksFormat "$LUKS_PART"

LUKSROOT=cryptroot
cryptsetup luksOpen $LUKS_PART $LUKSROOT

pvcreate "/dev/mapper/$LUKSROOT"
VGNAME=partitions
vgcreate "$VGNAME" "/dev/mapper/$LUKSROOT"

echo "Swap size: (example: 8G)"
read SWAP_SIZE
lvcreate -L "$SWAP_SIZE" -n SWAP "$VGNAME"
FSROOT=fsroot
lvcreate -l 100%FREE -n "$FSROOT" "$VGNAME"
vgchange -ay

mkswap -L swap /dev/partitions/SWAP
mkfs.btrfs -L "$FSROOT" "/dev/partitions/$FSROOT"
mount "/dev/partitions/$FSROOT" /mnt

cd /mnt
btrfs subvolume create root
btrfs subvolume create nix
btrfs subvolume create home

cd

umount /mnt
mount -o subvol=root "/dev/partitions/$FSROOT" /mnt

mkdir /mnt/nix
mount -o subvol=nix "/dev/partitions/$FSROOT" /mnt/nix

mkdir /mnt/home
mount -o subvol=home "/dev/partitions/$FSROOT" /mnt/home

umount $EFI_MNT
mkdir -p /mnt/boot/efi
mount "$EFI_PART" /mnt/boot/efi

swapon /dev/partitions/SWAP

mkdir -p /mnt/etc/nixos

cat <<END >> /mnt/etc/nixos/fde-configuration.nix
{ ... }:
{
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Configuration to use your Luks device
  boot.initrd.luks.devices = {
    "$LUKSROOT" = {
      device = "$LUKS_PART";
      preLVM = true;
    };
  };

  boot.initrd.availableKernelModules = [
    "aesni_intel"
    "cryptd"
  ];
}
END

nixos-generate-config --root /mnt

echo "SUCCESS"
