{ config
, lib
, pkgs
, modulesPath
, ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../modules/intel.nix
    ../modules/ssd.nix
    ../modules/physical-security.nix
    ../modules/networking.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.availableKernelModules = [
    "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"
  ];
  boot.initrd.kernelModules = [
    "dm-snapshot" "cryptd"
  ];
  boot.kernelModules = [
    "cryptd"
  ];

  boot.initrd.luks.devices = {
    "cryptroot" = {
      device = "/dev/disk/by-uuid/4718a029-55c0-42b9-bc7a-74cf6e5ec66c";
      preLVM = true;
    };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ee450296-2f1c-4307-9963-f3330e0bf317";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/ee450296-2f1c-4307-9963-f3330e0bf317";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/ee450296-2f1c-4307-9963-f3330e0bf317";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/9A05-C1C7";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/96f0c15b-3627-4c94-ac60-4e14998393f8"; }
    ];

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  nix.settings.max-jobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
