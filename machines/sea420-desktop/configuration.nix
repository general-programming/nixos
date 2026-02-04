{
  self,
  inputs,
  config,
  pkgs,
  ...
}:

let
  inherit (inputs)
    disko
    ;
in

{
  system.stateVersion = "26.05";

  imports = [
    disko.nixosModules.disko

    (self.lib.nixosModule "dns")
    (self.lib.nixosModule "gitops")
    (self.lib.nixosModule "glances-tty")
    (self.lib.nixosModule "impermanence")
    # (self.lib.nixosModule "network")
    # (self.lib.nixosModule "ssh")
    (self.lib.nixosModule "secureboot")
    (self.lib.nixosModule "nvidia")

    ./hardware.nix
    ./boot.nix
    ./disko.nix
  ];

  gitops = {
    enable = false;
    ref = "main";
  };

  networking = {
    hostName = "sea420-desktop";
    domain = "generalprogramming.org";
    hostId = "30b7aad6";
  };

  # Use the latest kernel for better hardware support, also pin zfs to unstable
  boot = {
    kernelPackages = pkgs.linuxPackages_6_18;
    zfs.package = pkgs.zfs_unstable;
  };

  # Networking
  networking.useDHCP = true;

  # Enable impermanence via /persist:
  impermanence.enable = true;
  fileSystems."/persist".neededForBoot = true;

  # Enable podman
  virtualisation.oci-containers.backend = "podman";
}
