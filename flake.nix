{
  description = "Nix Development Flake for your package";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs, flake-utils }:

    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python311;
        pythonPackages = python.pkgs;
      in
      {
        devShells.default = pkgs.mkShell {
          name = "andrew-ng-machine-learning";
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = with pythonPackages; [
            pkgs.stdenv.cc.cc.lib
            pkgs.poetry
            pip
            setuptools
            wheel
            venvShellHook
          ];
          venvDir = ".venv";
          src = null;
          #shellHook = ''
          #  # fixes libstdc++ issues and libgl.so issues
          #  LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/:/run/opengl-driver/lib/
          #'';
          postVenv = ''
            unset SOURCE_DATE_EPOCH
          '';
          postShellHook = ''
            unset SOURCE_DATE_EPOCH
            unset LD_PRELOAD

            # fixes libstdc++ issues and libgl.so issues
            LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/:/run/opengl-driver/lib/
            
            PYTHONPATH=$PWD/$venvDir/${python.sitePackages}:$PYTHONPATH
          '';
        };
      });
}
