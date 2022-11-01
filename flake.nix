{
  description = "My Android project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    android.url = "github:tadfisher/android-nixpkgs";
    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = { self, nixpkgs, devshell, flake-utils, android, zig }:
    {
      overlay = final: prev: {
        inherit (self.packages.${final.system}) android-sdk zig;
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
          zig = zig.packages.${system}.master;
          android-sdk = android.sdk.${system} (sdkPkgs: with sdkPkgs; [
            # Useful packages for building and testing.
            build-tools-33-0-0
            cmdline-tools-latest
            emulator
            platform-tools
            platforms-android-30
            ndk-25-1-8937393

            # Other useful packages for a development environment.
            # sources-android-30
            # system-images-android-30-google-apis-x86
            # system-images-android-30-google-apis-playstore-x86
          ]);
        };

        devShell = import ./devshell.nix { inherit pkgs; };
      }
    );
}
