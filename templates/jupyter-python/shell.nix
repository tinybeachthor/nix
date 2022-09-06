{ pkgs
, mkPython
}:

let
  pyEnv = mkPython {
    requirements = ''
      jupyterlab
      ipywidgets

      nbstripout == 0.3.7

      matplotlib
      numpy
    '';
    ignoreCollisions = true;
    ignoreDataOutdated = true;
  };
in

with pkgs;
mkShell {
  buildInputs = [
    git
    pre-commit

    pyEnv
  ];
}
