{
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "auto";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.htop
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMVk9i7FG7dc9r4ixwAJT7uPLH3UuqbwIgeZ7Ytmnpvv erin-laptop"
  ];

  system.stateVersion = "24.05";
}
