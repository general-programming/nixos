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
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
    };
    oci-containers.backend = "podman";
  };

  # punch holes for ports we might play with
  networking.firewall.allowedTCPPorts = [
      8000
      8080
  ];

  # Packages
  environment.systemPackages = with pkgs; [
    # human interactions with podman
    podman
    # flexing
    neofetch
    # KDE
    kdePackages.discover # Optional: Install if you use Flatpak or fwupd firmware update sevice
    kdePackages.kcalc # Calculator
    kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
    kdePackages.kclock # Clock app
    kdePackages.kcolorchooser # A small utility to select a color
    kdePackages.kolourpaint # Easy-to-use paint program
    kdePackages.ksystemlog # KDE SystemLog Application
    kdePackages.sddm-kcm # Configuration module for SDDM
    kdiff3 # Compares and merges 2 or 3 files or directories
    kdePackages.isoimagewriter # Optional: Program to write hybrid ISO files onto USB disks
    kdePackages.partitionmanager # Optional: Manage the disk devices, partitions and file systems on your computer
    # Non-KDE graphical packages
    hardinfo2 # System information and benchmarks for Linux systems
    vlc # Cross-platform media player and streaming server
    wayland-utils # Wayland utilities
    wl-clipboard # Command-line copy/paste utilities for Wayland
  ];

  programs.firefox = {
    enable = true;
  }

  # Desktop
  services.desktopManager.plasma6.enable = true;

  # Default display manager for Plasma
  services.displayManager.sddm = {
    enable = true;
    
    # To use Wayland (Experimental for SDDM)
    wayland.enable = true;
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment the following
    #jack.enable = true;
  };
}
