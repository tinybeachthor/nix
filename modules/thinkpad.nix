{ config, pkgs, ... }:

{
  boot.kernelModules = [
    "tp_smapi"
    "acpi_call"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    tp_smapi
    acpi_call
  ];
  environment.systemPackages = with pkgs; [
    acpi
  ];
}
