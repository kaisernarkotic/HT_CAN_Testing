# 🍳 cookin 👩‍🍳
{
  description = "flake for HT_CAN sym file for dbc output creation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }@inputs:
    let
    makePackageSet = pkgs: {
        default = pkgs.ht_can_pkg;
      };
      ht_can_dbc_overlay = final: prev: {
        ht_can_pkg = final.callPackage ./default.nix { };
      };
      my_overlays = [
        ht_can_dbc_overlay
      ];
      system = builtins.currentSystem;
      x86_pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ self.overlays.default ];
      };

      arm_pkgs = import nixpkgs {
        system = "aarch64-linux";
        overlays = [ self.overlays.default ];
      };

      packageSets = {
        "x86_64-linux" = makePackageSet x86_pkgs;
        "aarch64-linux" = makePackageSet arm_pkgs;
        # Add more systems as needed
      };
    in {

      overlays.default = nixpkgs.lib.composeManyExtensions my_overlays;

      packages = packageSets;
      devShells.x86_64-linux.default = x86_pkgs.mkShell rec {
        # Update the name to something that suites your project.
        name = "nix-devshell";
        packages = with x86_pkgs; [
          # Development Tools
          python311Packages.cantools
          # ht_can_pkg 
        ];

      };

    };
}
