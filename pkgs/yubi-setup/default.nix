{ writeShellScriptBin
, symlinkJoin
, lib
, stdenv
, openssl
, modulesPath
}:

let
  tools = {
    rbtohex = writeShellScriptBin "rbtohex" ''
      ( od -An -vtx1 | tr -d ' \n' )
    '';
    hextorb = writeShellScriptBin "hextorb" ''
      ( tr '[:lower:]' '[:upper:]' | sed -e 's/\([0-9A-F]\{2\}\)/\\\\\\x\1/gI'| xargs printf )
    '';

    pbkdf2-sha512 = stdenv.mkDerivation {
      name = "pbkdf2-sha512";
      version = "latest";
      buildInputs = [
        openssl
      ];
      src = ./.;
      buildPhase = ''
        cc -O3 \
        -I${openssl.dev}/include -L${openssl.out}/lib \
        ${modulesPath}/system/boot/pbkdf2-sha512.c \
        -o pbkdf2-sha512 -lcrypto
      '';
      installPhase = ''
        mkdir -p $out/bin
        install -m755 pbkdf2-sha512 $out/bin/pbkdf2-sha512
      '';
    };

    fresh-setup-fde-yubi = writeShellScriptBin "fresh-setup-fde-yubi"
      (builtins.readFile ./fresh-setup-fde-yubi.sh);
  };

in
  symlinkJoin {
    name = "yubi-setup";
    paths = lib.attrValues tools;
  }
