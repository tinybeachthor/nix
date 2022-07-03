{ config, pkgs, ... }:

{
  boot.kernelModules = [
    "i915" 		  # intel graphics
    "kvm-intel"	# kernel-based virtual machine
    "coretemp"	# intel cpu temperature reading
  ];

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

    opengl.extraPackages = with pkgs; [
      vaapiIntel
    ];
  };
}
