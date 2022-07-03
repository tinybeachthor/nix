#!/bin/sh

set -ex

SALT_LENGTH=16
KEY_LENGTH=512
KEY_LENGTH_BYTES=$(($KEY_LENGTH / 8))
ITERATIONS=1000000

# setup yubikey
ykpersonalize -2 -ochal-resp -ochal-hmac

# get random salt
salt="$(dd if=/dev/random bs=1 count=$SALT_LENGTH 2>/dev/null | rbtohex)"

# read passphrase
echo "Enter passphrase"
read k_user

# set yubikey challenge
challenge="$(echo -n $salt | openssl dgst -binary -sha512 | rbtohex)"

# get yubikey response
response="$(ykchalresp -2 -x $challenge 2>/dev/null)"

# create luks key
k_luks="$(echo -n $k_user | pbkdf2-sha512 $KEY_LENGTH_BYTES $ITERATIONS $response | rbtohex)"

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

STORAGE=/crypt-storage/default
mkdir -p "$(dirname $EFI_MNT$STORAGE)"

echo -ne "$salt\n$ITERATIONS" > crypt-default
cat crypt-default
echo
cp crypt-default $EFI_MNT$STORAGE

CIPHER=aes-xts-plain64
HASH=sha512

echo -n "$k_luks" | hextorb | cryptsetup luksFormat --cipher="$CIPHER" --key-size="$KEY_LENGTH" --hash="$HASH" --key-file=- "$LUKS_PART"

LUKSROOT=cryptroot
echo -n "$k_luks" | hextorb | cryptsetup luksOpen $LUKS_PART $LUKSROOT --key-file=-
echo -ne "$k_luks" > key

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
mkdir /mnt/boot
mount "$EFI_PART" /mnt/boot

swapon /dev/partitions/SWAP

mkdir -p /mnt/etc/nixos

cat <<END >> /mnt/etc/nixos/fde-configuration.nix
{ ... }:
{
  # Minimal list of modules to use the EFI system partition and the YubiKey
  boot.initrd.kernelModules = [ "vfat" "nls_cp437" "nls_iso8859-1" "usbhid" ];

  # Enable support for the YubiKey PBA
  boot.initrd.luks.yubikeySupport = true;

  # Configuration to use your Luks device
  boot.initrd.luks.devices = {
    "$LUKSROOT" = {
      device = "$LUKS_PART";
      preLVM = true;
      yubikey = {
        slot = 2;
        twoFactor = true; # Set to false if you did not set up a user password.
        saltLength = $SALT_LENGTH;
        storage = {
          device = "$EFI_PART";
          fsType = "vfat";
          path = "$STORAGE";
        };
        keyLength = $KEY_LENGTH_BYTES;
        iterationStep = 0;
        gracePeriod = 10;
      };
    };
  };
}
END

nixos-generate-config --root /mnt

echo "SUCCESS"
