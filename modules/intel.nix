{ config, pkgs, ... }:

{
  boot.initrd.availableKernelModules = [
    "aesni_intel"
  ];
  boot.kernelModules = [
    "i915" 		  # intel graphics
    "kvm-intel"	# kernel-based virtual machine
    "coretemp"	# intel cpu temperature reading
    "aesni_intel"
  ];

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

    graphics.extraPackages = with pkgs; [
      vaapiIntel
    ];
  };
}
