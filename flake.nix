{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells = {
          default = pkgs.mkShell {
            CHROME_BIN = "${pkgs.lib.getExe (
              pkgs.chromium.override {
                commandLineArgs = [
                  "--no-sandbox"
                  "--window-size=1920,1080"
                  "--disable-dev-shm-usage"
                  "--no-first-run"
                ];
              }
            )}";
            packages = [
              pkgs.nodejs

              # Alternatively, you can use a specific major version of Node.js

              # pkgs.nodejs-22_x

              # Use corepack to install npm/pnpm/yarn as specified in package.json
              pkgs.corepack

              # Required to enable the language server
              pkgs.nodePackages.typescript
              pkgs.nodePackages.typescript-language-server

              # Python is required on NixOS if the dependencies require node-gyp

              # pkgs.python3
            ];
          };
        };
      }
    );
}
