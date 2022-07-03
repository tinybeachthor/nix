{ pkgs, lib, ... }:

{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
