{ writeShellScriptBin
, symlinkJoin
, lib
, stdenv
, openssl
, modulesPath
}:

let
  tools = {
    fresh-setup-fde = writeShellScriptBin "fresh-setup-fde"
      (builtins.readFile ./fresh-setup-fde.sh);
  };

in
  symlinkJoin {
    name = "fde-setup";
    paths = lib.attrValues tools;
  }
