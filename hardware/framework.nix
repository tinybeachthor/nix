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
    ../modules/systemd-boot.nix
    ../modules/physical-security.nix
    ../modules/networking.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.availableKernelModules = [
    "xhci_pci" "thunderbolt" "nvme" "usb_storage" "usbhid" "sd_mod"
  ];
  boot.initrd.kernelModules = [
    # Minimal list of modules to use the EFI system partition and the YubiKey
    "vfat" "nls_cp437" "nls_iso8859-1" "usbhid"
    "dm-snapshot"
  ];

  # Enable support for the YubiKey PBA
  boot.initrd.luks.yubikeySupport = true;

  # Configuration to use your Luks device
  boot.initrd.luks.devices = {
    "cryptroot" = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
      yubikey = {
        slot = 2;
        twoFactor = true; # Set to false if you did not set up a user password.
        saltLength = 16;
        storage = {
          device = "/dev/nvme0n1p1";
          fsType = "vfat";
          path = "/crypt-storage/default";
        };
        keyLength = 64;
        iterationStep = 0;
        gracePeriod = 10;
      };
    };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/5d4943bf-85a4-44cd-b0da-5c5b5fa3138b";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/5d4943bf-85a4-44cd-b0da-5c5b5fa3138b";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/5d4943bf-85a4-44cd-b0da-5c5b5fa3138b";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7FB4-89CB";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/fcca575f-7f0d-462a-94b2-387483d80760"; }
    ];

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
