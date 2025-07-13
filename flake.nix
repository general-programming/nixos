{
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

      lix = {
        url = "git+https://git@git.lix.systems/lix-project/lix";
      };

      lix-module = {
        url = "git+https://git.lix.systems/lix-project/nixos-module";
        inputs.lix.follows = "lix";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      disko = {
        url = "github:nix-community/disko";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  };

  outputs =
    {
      lix-module,
      nixpkgs,
      disko,
      nixos-facter-modules,
      ...
    }:
    {
      nixosConfigurations.proxmox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          lix-module.nixosModules.default
          disko.nixosModules.disko
          ./disk-configs/single.nix
          ./configuration.nix
        ];
      };

      # Use this for all other targets
      # nixos-anywhere --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
      nixosConfigurations.generic = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          lix-module.nixosModules.default
          disko.nixosModules.disko
          ./disk-configs/single.nix
          ./configuration.nix
          ./hardware-configuration.nix
        ];
      };

      # Slightly experimental: Like generic, but with nixos-facter (https://github.com/numtide/nixos-facter)
      # nixos-anywhere --flake .#generic-nixos-facter --generate-hardware-config nixos-facter facter.json <hostname>
      nixosConfigurations.generic-nixos-facter = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          lix-module.nixosModules.default
          disko.nixosModules.disko
          ./disk-configs/single.nix
          ./configuration.nix
          nixos-facter-modules.nixosModules.facter
          {
            config.facter.reportPath =
              if builtins.pathExists ./facter.json then
                ./facter.json
              else
                throw "Have you forgotten to run nixos-anywhere with `--generate-hardware-config nixos-facter ./facter.json`?";
          }
        ];
      };

      # core hosts
      nixosConfigurations.fmt2-core = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          lix-module.nixosModules.default
          disko.nixosModules.disko
          ./configuration.nix
          ./hosts/fmt2-core.nix
          ./disk-configs/zfs-mirror.nix
          ./roles/dns/main.nix
          ./roles/consul/fmt2.nix
        ];
      };
    };
      nixosConfigurations.sea1-core = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          lix-module.nixosModules.default
          disko.nixosModules.disko
          ./configuration.nix
          ./hosts/sea1-core.nix
          ./disk-configs/zfs-mirror.nix
          ./roles/dns/main.nix
          ./roles/consul/sea1.nix
        ];
      };
}
