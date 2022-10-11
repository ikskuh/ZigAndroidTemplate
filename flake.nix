{
  description = "My Android project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    android.url = "github:tadfisher/android-nixpkgs";
  };

  outputs = { self, nixpkgs, devshell, flake-utils, android }:
    {
      overlay = final: prev: {
        inherit (self.packages.${final.system}) android-sdk android-studio;
      };
    }
    //
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            devshell.overlay
            self.overlay
          ];
        };
      in
      {
        packages = {
          android-sdk = android.sdk.${system} (sdkPkgs: with sdkPkgs; [
            # Useful packages for building and testing.
            build-tools-30-0-2
            cmdline-tools-latest
            emulator
            platform-tools
            platforms-android-30

            # Other useful packages for a development environment.
            # sources-android-30
            # system-images-android-30-google-apis-x86
            # system-images-android-30-google-apis-playstore-x86
          ]);

          android-studio = pkgs.androidStudioPackages.stable;
          # android-studio = pkgs.androidStudioPackages.beta;
          # android-studio = pkgs.androidStudioPackages.preview;
          # android-studio = pkgs.androidStudioPackage.canary;
        };

        devShell = import ./devshell.nix { inherit pkgs; };
      }
    );
}
