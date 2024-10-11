{
  description = "nixos config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
  };
  outputs = { nixpkgs, ... } @ inputs:
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    hostName = "maybenixlaptop";
    diskName = "/dev/nvme0n1";
  in {
    nixosConfigurations = {
      ${hostName} = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./configuration.nix
          inputs.disko.nixosModules.default
          (import ./disko.nix { device = diskName; })
          inputs.impermanence.nixosModules.impermanence
        ];
      };
    };
  };
}
