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
      # https://github.com/NixOS/nixpkgs/issues/445447
      #url = "github:nix-community/home-manager/master";
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixd.url = "github:nix-community/nixd";
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
      # https://github.com/NixOS/nixos-hardware/blob/master/flake.nix#L119
      nixos-hardware.nixosModules.focus-m2-gen1
    ];

    homes.modules = with inputs; [
      catppuccin.homeModules.catppuccin
    ];
  });
}
