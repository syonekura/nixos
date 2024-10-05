{
  description = "SY NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;

      snowfall = {
        meta = {
          name = "sy";
          title = "Seba Yonekura";
        };

        namespace = "sy";
      };
    };
  in (lib.mkFlake {
    channels-config = {
      allowUnfree = true;
    };
    inherit inputs;
    src = ./.;

    systems.modules.nixos = with inputs; [
      home-manager.nixosModules.home-manager
      catppuccin.nixosModules.catppuccin
      disko.nixosModules.disko
    ];

    homes.modules = with inputs; [
      catppuccin.homeManagerModules.catppuccin
    ];

    # Tilapio is our test VM
    systems.hosts.tilapio.modules = [
      (import ./disks/default.nix {
        inherit lib;
        disks = ["/dev/vda"];
      })
    ];
  });
}
