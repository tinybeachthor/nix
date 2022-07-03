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
    ../modules/thinkpad.nix
    ../modules/wacom.nix
    ../modules/ssd.nix
    ../modules/systemd-boot.nix
    ../modules/physical-security.nix
    ../modules/networking.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.availableKernelModules = [
    "xhci_pci" "nvme" "rtsx_pci_sdmmc"
  ];

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  fileSystems."/nix" =
    { device = "/dev/disk/by-label/store";
      fsType = "ext4";
      neededForBoot = true;
      options = [ "noatime" ];
    };
  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/SWAP"; }
    ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # Trackpoint
  hardware.trackpoint = {
    enable = true;
    emulateWheel = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "19.09"; # Did you read the comment?
}
