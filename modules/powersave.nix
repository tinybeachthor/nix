{ config, lib, pkgs, ... }:

let
  ifModule = name: options:
    if lib.any (m: m == name) config.boot.kernelModules
       then options
       else [];
in
{
  config.boot = {
    kernelParams =
      let
        pcie_aspm = ifModule "pcie_aspm" [
          "pcie_aspm.policy=powersave"
        ];
        iwlwifi = ifModule "iwlwifi" [
          "iwlwifi.power_save=Y"
        ];
        i915 = ifModule "i915" [
          "i915.enable_rc6=7"
          "i915.enable_psr=2"
          "i915.enable_fbc=1"
          "i915.lvds_downclock=1"
          "i915.semaphores=1"
        ];
      in
        pcie_aspm ++ iwlwifi ++ i915;
  };

  config.powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  config.services = {
    tlp.enable = true;
    tlp.settings = {
      TLP_DEFAULT_MODE = "BAT";

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_BOOST_ON_AC = 1;
      SCHED_POWERSAVE_ON_AC=0;

      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 25;
      CPU_BOOST_ON_BAT = 0;
      SCHED_POWERSAVE_ON_BAT=1;
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_HWP_ON_BAT = "power";
      PCIE_ASPM_ON_BAT = "powersupersave";
      SATA_LINKPWR_ON_BAT = "min_power med_power_with_dipm";
    };
  };
}
